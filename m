From: Donald Buczek <buczek@molgen.mpg.de>
Subject: Re: Ordering problems with 3ware controller
Date: Wed, 16 Nov 2016 22:24:31 +0100
Message-ID: <feacce75-237e-c514-eb5a-9d4a83ee5ed7@molgen.mpg.de>
References: <a41b4bab-edb7-34ab-eb76-7ff4d6e3f677@molgen.mpg.de>
 <yq1bmxpr0wj.fsf@sermon.lab.mkp.net>
 <49d06c24-24a0-e0fa-0cae-af8ea79a38e0@molgen.mpg.de>
 <yq11syjo2py.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------CC09AB14305978B134879F54"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.molgen.mpg.de ([141.14.17.9]:40587 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753265AbcKPVdE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Nov 2016 16:33:04 -0500
In-Reply-To: <yq11syjo2py.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dvteam@molgen.mpg.de, Paul Menzel <pmenzel@molgen.mpg.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------CC09AB14305978B134879F54
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit


On 10.11.2016 14:59, Martin K. Petersen wrote:
>>>>>> "Paul" == Paul Menzel <pmenzel@molgen.mpg.de> writes:
> Paul,
>
>>> Linux does not provide device discovery ordering guarantees. You need
>>> to fix your scripts to use UUIDs, filesystem labels, or DM devices to
>>> get stable naming.
> Paul> Indeed. But it worked for several years, so that *something* must
> Paul> have changed that the ordering of the result of `getdents64` is
> Paul> different now.
>
> Could be changes in the PCI or platform code that causes things to be
> enumerated differently. Whatever it is, it has nothing to do with the
> 3ware drivers themselves since they have been dormant for a long time.
>

Right. We further tracked it down. In fact its not a matter of driver 
initialization order but of the way sysfs/kernfs hashes its object names 
and thereby defines the order of names returned by getdents64 calls. In 
fs/kernfs/dir.h the names are inserted into a red-black tree ordered by 
the hashes over their names (and possibly namespace pointer, which in 
our case is zero).

I've walked the rbtrees of the kernfs_node structs from 
/sys/class/scsi_host showing their addresses, the hash values and the 
names in a 4.4.27 system:

root:cu:/home/buczek/autofs/# ./peek-3w

ffff88046d847640 : 11bf1ddd : host0
ffff88046c56d3e8 : 11bf1e8d : host1
ffff88046c571c58 : 11bf1f3d : host2
ffff88046c572550 : 11bf1fed : host3
ffff88046c577dc0 : 11bf209d : host4
ffff88046a4bbaf0 : 11bf214d : host5

As can be seen, in 4.4 the hash algorithm happened to produce increasing 
hash values for names like "host0","host1","host2",... In 4.8.6 the hash 
values seem to be more random:

root:gynaekophobie:/home/buczek/autofs/# ./peek-3w

ffff88041df9a7f8 : 074af64b : host0
ffff88081db40528 : 1009cd9b : host9
ffff88041d3fba50 : 1c512bfb : host7
ffff88181d19c000 : 28988a5b : host5
ffff88041df5a780 : 34dfe8bb : host3
ffff88041d3f5e10 : 4127471b : host1
ffff88041ccbd258 : 562d7ccb : host8
ffff88201cd5f960 : 6274db2b : host6
ffff88141e2d0ca8 : 6ebc398b : host4
ffff88041df599d8 : 7b0397eb : host2

The relevant commit is 703b5fa  which includes

  static inline unsigned long end_name_hash(unsigned long hash)
  {
-       return (unsigned int)hash;
+       return __hash_32((unsigned int)hash);
  }

__hash_32 is a multiplication by 0x61C88647 ( hash.h )

And this exactly is the difference between the hash value of "host0" on 
the 4.4 and the 4.8 system:

   DB<2> x sprintf '%x',0x11bf1ddd*0x61C88647
0  '6c750ef074af64b'

The bug, of course, is in the userspace tool tw_cli which wrongly 
assumes that the names would be returned in the "right" order by getdents.

As a dirty workaround, I've created a new wrapper, which uses ptrace to 
pause the program on return from SYS_getdents64 and sorts the values 
returned from the system call in the memory of the target process.

I append the source of the wrapper.
-- 

Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433


--------------CC09AB14305978B134879F54
Content-Type: text/x-csrc;
 name="tw_cli.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tw_cli.c"

#define _GNU_SOURCE         /* See feature_test_macros(7) */
#include <unistd.h>
#include <sys/syscall.h>   /* For SYS_xxx definitions */
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/ptrace.h>
#include <errno.h>
#include <signal.h>
#include <sys/user.h>
#include <syscall.h>
#include <fcntl.h>
#include <stdint.h>
#include <string.h>
#include <stdarg.h>

#include <regex.h>

typedef uint64_t u64;
typedef int64_t s64;

/* from include/linux/dirent.h : */

struct linux_dirent64 {
        u64             d_ino;
        s64             d_off;
        unsigned short  d_reclen;
        unsigned char   d_type;
        char            d_name[0];
};

void die(char *fmt,...) {
	va_list ap;
	va_start(ap,fmt);
	vfprintf(stderr,fmt,ap);
	exit(1);
}

void die_regerror(int status,regex_t *re) {
	char msg[80];
	int s;
	s=regerror(status,re,msg,sizeof(msg));
	die("regex: %s\n",msg);
}

int hostnum(char *hostname) {
	static regex_t *re=NULL;
	int status;
	regmatch_t match[2];

	if (!re) {
		re=malloc(sizeof(*re));
		if (!re) die("");
		status=regcomp(re,"^host([0-9]+)$",REG_EXTENDED);
		if (status) die_regerror(status,re);
	}

	status=regexec(re,hostname,sizeof(match)/sizeof(*match),match,0);
	if (status==0) {
		char c=hostname[match[1].rm_eo];
		match[1].rm_eo='\0';
		int num=atoi(&hostname[match[1].rm_so]);
		match[1].rm_eo=c;
		return(num);
	} else if (status==REG_NOMATCH) {
		return(-1);
	} else {
		die_regerror(status,re);
	}
}

struct sortentry {
	struct linux_dirent64 *dirent;
	int hostnum;
};

int compare_sortentry(const void *vp1,const void *vp2) {
	struct sortentry *p1=(struct sortentry *)vp1;
	struct sortentry *p2=(struct sortentry *)vp2;

	if (p1->hostnum!=-1 && p2->hostnum!=-1) {
		return p1->hostnum<p2->hostnum ? -1 : p1->hostnum>p2->hostnum ? 1 : 0;
	}
	return strcmp(p1->dirent->d_name,p2->dirent->d_name);
}

void fix_memory(pid_t pid,size_t count,void *dirp) {

	char *memfilename;
	int fd;

	char *dirents_unsorted,*dirents_sorted;
	struct sortentry *sort_array;
	struct sortentry *sort_entry;

	size_t s;

	int entry_count;
	int bpos;
	int i;

	struct linux_dirent64 *d;

	if (count==0) return;

	if (asprintf(&memfilename,"/proc/%d/mem",pid)==-1) die("%m\n");

	fd=open(memfilename,O_RDWR);
	if (fd==-1) die (memfilename);

	dirents_unsorted=malloc(count);
	if(!dirents_unsorted) die ("");

	if (lseek(fd,(off_t)dirp,SEEK_SET)<-1) die("%s: %m\n",memfilename);
	s=read(fd,dirents_unsorted,count);
	if (s == -1) die("%s: %m\n",memfilename);
	if (s != count) die("short reads on childs memory not implemented");

	entry_count=0;
	for (bpos=0;bpos<count;) {
		d = (struct linux_dirent64 *) (dirents_unsorted + bpos);
		entry_count++;
		bpos+=d->d_reclen;
	}

	sort_array=malloc(entry_count*sizeof (*sort_array));
	if (!sort_array) die ("");

	sort_entry=sort_array;
	for (bpos=0;bpos<count;) {
		d = (struct linux_dirent64 *) (dirents_unsorted + bpos);
		sort_entry->dirent=d;
		sort_entry->hostnum=hostnum(d->d_name);
		sort_entry++;
		bpos+=d->d_reclen;
	}

	// for (i=0;i<entry_count;i++) { printf("ary[%d] : %p : %s : %d\n",i,sort_array[i].dirent,sort_array[i].dirent->d_name,sort_array[i].hostnum); }

	qsort(sort_array,entry_count,sizeof(*sort_array),compare_sortentry);

	// for (i=0;i<entry_count;i++) { printf("ary[%d] : %p : %s : %d\n",i,sort_array[i].dirent,sort_array[i].dirent->d_name,sort_array[i].hostnum); }

	dirents_sorted=malloc(count);
	if(!dirents_sorted) die ("%m\n");

	bpos=0;
	for (i=0;i<entry_count;i++) {
		d = (struct linux_dirent64 *) (dirents_sorted + bpos);
		memcpy(d,sort_array[i].dirent,sort_array[i].dirent->d_reclen);
		bpos+=sort_array[i].dirent->d_reclen;
	}

	// for (bpos=0;bpos<count;) { d = (struct linux_dirent64 *) (dirents_sorted + bpos); printf(" --> %s\n",d->d_name); bpos+=d->d_reclen; }

	if (lseek(fd,(off_t)dirp,SEEK_SET)<-1) die("%s: %m\n",memfilename);
	s=write(fd,dirents_sorted,count);
	if (s == -1) die(memfilename);
	if (s != count) die("internal error: short write");

	close(fd);

	free(memfilename);
	free(dirents_unsorted);
	free(dirents_sorted);
	free(sort_array);
}

int main(int argc, char **argv) {
	pid_t pid;
	int status;
	int syscall_state=0;
	struct user user;

	static const char *TW_CLI_ORIG="/root/bin/tw_cli.exe";

	pid=fork();
	if (pid==0) {
		if (ptrace(PTRACE_TRACEME,NULL,NULL)==-1) die("ptrace: %m\n");
		execv(TW_CLI_ORIG,argv);
		die("%s: %m\n",TW_CLI_ORIG);
	} else if (pid==-1) {
		die("fork: %m\n");
	}

	while(1) {
		pid=wait(&status);
		if (pid==-1) die("wait: %m\n");
		if (WIFSIGNALED(status)) {
			int signal=WTERMSIG(status);
			die("child got signal %d - exiting\n",signal);
		} else if (WIFSTOPPED(status)) {
			int signal=WSTOPSIG(status);
			if (signal==SIGTRAP) {
				if(ptrace(PTRACE_SETOPTIONS,pid,NULL,PTRACE_O_TRACESYSGOOD)==-1) die("ptrace: %m\n");
				if(ptrace(PTRACE_SYSCALL,pid,NULL,NULL)==-1) die ("ptrace: %m\n");
			} else if (signal==SIGTRAP|0x80) {
				if (syscall_state==1) {
					if(ptrace(PTRACE_GETREGS,pid,NULL,&user)==-1) die("ptrace: %m\n");;

					/* the 0xFF is not right but rax is 0xffffffffffffffda , _NR_getdents64  is 217 which is 0xda
					* and the syscall interface somehow fixes is */

					if ((unsigned char)(user.regs.orig_rax & 0xFF) == SYS_getdents64) {
						fix_memory(pid,(int)user.regs.rax,(void *)user.regs.rsi);
					}
				}
				syscall_state=1-syscall_state;
				if(ptrace(PTRACE_SYSCALL,pid,NULL,NULL)==-1) die("ptrace: %m\n");;
			} else {
				die("child stopped by  signal %d - exiting\n",signal);
			}
		} else if (WIFEXITED(status)) {
			if (WEXITSTATUS(status)) {
				exit(1);
			} else {
				exit(0);
			}
		} else {
			die("unexpected return from wait. status=%08x - exiting\n",status);
		}
	}
}


--------------CC09AB14305978B134879F54--
