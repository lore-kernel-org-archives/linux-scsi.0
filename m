From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: scsi: sg: assorted memory corruptions
Date: Thu, 1 Feb 2018 01:03:40 -0500
Message-ID: <c0a7ec39-e357-9db6-cf12-ff9c46259f26@interlog.com>
References: <CACT4Y+b0pizvOAxtWQ-TGCRAYvHXdv79BAEaXh50W6vF8gBvkQ@mail.gmail.com>
 <1516638634.2545.0.camel@wdc.com>
 <097921fa-52c5-8b2b-f564-4b24d9720478@interlog.com>
 <CACT4Y+aEx0ie3qjx6afCYV2vN7gYii0uupKWPXaNTnWUmhdHQw@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------908CB96317416B6C4B738BD1"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+aEx0ie3qjx6afCYV2vN7gYii0uupKWPXaNTnWUmhdHQw@mail.gmail.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>, "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------908CB96317416B6C4B738BD1
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2018-01-30 07:22 AM, Dmitry Vyukov wrote:
> Uh, I've answered this a week ago, but did not notice that Doug
> dropped everybody from CC. Reporting to all.
> 
> On Mon, Jan 22, 2018 at 8:16 PM, Douglas Gilbert <dgilbert@interlog.com> wrote:
>> On 2018-01-22 02:06 PM, Dmitry Vyukov wrote:
>>>
>>> On Mon, Jan 22, 2018 at 7:57 PM, Douglas Gilbert <dgilbert@interlog.com>
>> Please show me the output of 'lsscsi -g' on your test machine.
>> /dev/sg0 is often associated with /dev/sda which is often a SATA
>> SSD (or a virtualized one) that holds the root file system.
>> With the sg pass-through driver it is relatively easy to write
>> random (user provided data) over the root file system which will
>> almost certainly "root" the system.
> 
> 
> This is pretty standard qemu vm started with:
> 
> qemu-system-x86_64 -hda wheezy.img -net user,host=10.0.2.10 -net nic
> -nographic -kernel arch/x86/boot/bzImage -append "console=ttyS0
> root=/dev/sda earlyprintk=serial " -m 2G -smp 4
> 
> # lsscsi -g
> [0:0:0:0]    disk    ATA      QEMU HARDDISK    0     /dev/sda   /dev/sg0

With lk 4.15.0-rc9 I can run your test program (with some additions, see
attachment) for 30 minutes against a scsi_debug simulated disk. You can
easily replicate this test just run 'modprobe scsi_debug' and a third
line should appear in your lsscsi output. The new device will most likely
be /dev/sg2 .

With lk 4.15.0 (release) running against a SAS SSD (SEAGATE ST200FM0073),
the test has  been running 20 minutes and counting without problems. That
is using a LSI HBA with the mpt3sas driver.

> [1:0:0:0]    cd/dvd  QEMU     QEMU DVD-ROM     2.0.  /dev/sr0   /dev/sg1
> 
> # readlink /sys/class/scsi_generic/sg0
> ../../devices/pci0000:00/0000:00:01.1/ata1/host0/target0:0:0/0:0:0:0/scsi_generic/sg0
> 
> # cat /sys/class/scsi_generic/sg0/device/vendor
> ATA

^^^^^
That subsystem is the culprit IMO, most likely libata.

Until you can show this test failing on something other than an
ATA disk, then I will treat this issue as closed.

Doug Gilbert


>>>> Perhaps it misbehaves when it
>>>> gets a SCSI command in the T10 range (i.e. not vendor specific) with
>>>> a 9 byte cdb length. As far as I'm aware T10 (and the Ansi committee
>>>> before it) have never defined a cdb with an odd length.
>>>>
>>>> For those that are not aware, the sg driver is a relatively thin
>>>> shim over the block layer, the SCSI mid-level, and a low-level
>>>> driver which may have another kernel driver stack underneath it
>>>> (e.g. UAS (USB attached SCSI)). The previous report from syzkaller
>>>> on the sg driver ("scsi: memory leak in sg_start_req") has resulted
>>>> in one accepted patch on the block layer with probably more to
>>>> come in the same area.
>>>>
>>>> Testing the patch Dmitry gave (with some added error checks which
>>>> reported no problems) with the scsi_debug driver supplying /dev/sg0
>>>> I have not seen any problems running that test program. Again
>>>> there might be a very slow memory leak, but if there is I don't
>>>> believe it is in the sg driver.
>>>
>>>
>>> Did you run it in a loop? First runs pass just fine for me too.
>>
>>
>> Is thirty minutes long enough ??
> 
> 
> Yes, it certainly should be enough. Here is what I see:
> 
> 
> # while ./a.out; do echo RUN; done
> RUN
> RUN
> RUN
> RUN
> RUN
> RUN
> RUN
> [  371.977266] ==================================================================
> [  371.980158] BUG: KASAN: double-free or invalid-free in
> __put_task_struct+0x1e7/0x5c0
> ....
> 
> 
> Here is full execution trace of the write call if that will be of any help:
> https://gist.githubusercontent.com/dvyukov/14ae64c3e753dedf9ab2608676ecf0b9/raw/9803d52bb1e317a9228e362236d042aaf0fa9d69/gistfile1.txt
> 
> This is on upstream commit 0d665e7b109d512b7cae3ccef6e8654714887844.
> Also attaching my config just in case.
> 


--------------908CB96317416B6C4B738BD1
Content-Type: text/x-csrc;
 name="sg_syzk_next_cbd.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sg_syzk_next_cbd.c"

// autogenerated by syzkaller (http://github.com/google/syzkaller)
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#include <stdio.h>
#include <string.h>
#include <errno.h>

#define SG_NEXT_CMD_LEN 0x2283

static const char * usage = "sg_syzk_next_cdb <sg_dev>    # (e.g. '/dev/sg3') ";

int main(int argc, const char * argv[])
{
  int res, err;
  int fd;
  long len = 9;
  char* p = "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x47\x00\x00\x24\x00"
            "\x00\x00\x00\x00\x00\x1c\xbb\xac\x14\x00\xaa\xe0\x00\x00\x01"
            "\x00\x07\x07\x00\x00\x59\x08\x00\x00\x00\x80\xfe\x7f\x00\x00\x01";
    const char * dev_name;
    struct stat a_stat;

    if (argc < 2) {
        fprintf(stderr, "Usage: %s\n", usage);
        return 1;
    }
    dev_name = argv[1];
    if (0 != stat(dev_name, &a_stat)) {
        err = errno;
        fprintf(stderr, "Unable to stat %s, err: %s\n", dev_name,
                strerror(err));
        return 1;
    }
    if ((a_stat.st_mode & S_IFMT) != S_IFCHR) {
        fprintf(stderr, "Expected %s, to be sg device\n", dev_name);
        return 1;
    }
  fd = open(dev_name, O_RDWR);
  if (fd < 0) {
	err = errno;
	fprintf(stderr, "open(%s) failed: %s [%d]\n", dev_name, strerror(err),
		err);
  }
  res = ioctl(fd, SG_NEXT_CMD_LEN, &len);
  if (res < 0) {
	err = errno;
	fprintf(stderr, "ioctl failed: %s [%d]\n", strerror(err), err);
  }
  res = write(fd, p, 46);
  if (res < 0) {
	err = errno;
	fprintf(stderr, "write failed: %s [%d]\n", strerror(err), err);
  }
  return 0;
}

--------------908CB96317416B6C4B738BD1--
