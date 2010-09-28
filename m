From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: I/O topology fixes for big physical block size
Date: Tue, 28 Sep 2010 16:36:42 -0500
Message-ID: <4CA25FEA.6040505@redhat.com>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>	<4CA0CC38.5010804@fusionio.com> <yq1pqvzcddq.fsf@sermon.lab.mkp.net>	<4CA118FF.1080100@fusionio.com> <yq18w2mddav.fsf@sermon.lab.mkp.net>	<20100927231551.GA15653@redhat.com> <4CA16F6A.1090904@fusionio.com>	<4CA17B13.7080801@redhat.com> <20100928141545.GA21587@redhat.com>	<20100928205741.GA22257@thunk.org> <yq162xpa7dj.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <yq162xpa7dj.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ted Ts'o <tytso@mit.edu>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <jaxboe@fusionio.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:

>>>>>> "Ted" == Ted Ts'o <tytso@mit.edu> writes:
>>>>>>             
>
> Ted> Can we decide soon what the right thing should be?  I'm about to
> Ted> release e2fsrogs 1.41.13, and if I should put in some sanity
> Ted> checking code so mke2fs does something sane when it sees a 1M
> Ted> physical block size, I can do that.
>
> I don't think it's entirely clear what the "right thing" would be.
>
> Let's ignore the 1MB block size for now. That's clearly a fluke and a
> buggy device. But there are SSDs that will advertise an 8KiB physical
> block size. And apparently 16KiB devices are in the pipeline.
>   
Ok, then it sounds like mkfs.ext4's refusal to make fs blocksize less
than device physical sectorsize without -F is broken, and that should
be removed.  I'd say issue a warning in the case but if there's a 16k
physical device maybe there's no point in warning either?

> How do we want to handle these devices? Allowing blocks bigger than the
> page size is going to be painful.
>
> So the question is whether we can tweak the filesystem layout in a way
> that would alleviate the pain without having to change the filesystem
> block size in the traditional sense.
>
> At least we're talking about SSDs and arrays here. I assume the partial
> block write penalty for these devices would be smaller than it is for
> rotating media.
>
>   
I guess it must be.

Anyway here's a patch to remove the force requirement and just give the
user whatever they want, since apparently we can't avoid fs blocksize
less than physical sector size in general.  It does still warn
that the fs blocksize is less than physical sectorsize, but *shrug*


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index add7c0c..6010fc1 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1634,17 +1634,15 @@ static void PRS(int argc, char *argv[])
 					ext2fs_blocks_count(&fs_param) /
 					(blocksize / 1024));
 	} else {
-		if (blocksize < lsector_size ||			/* Impossible */
-		    (!force && (blocksize < psector_size))) {	/* Suboptimal */
+		if (blocksize < lsector_size) {			/* Impossible */
 			com_err(program_name, EINVAL,
 				_("while setting blocksize; too small "
 				  "for device\n"));
 			exit(1);
-		} else if (blocksize < psector_size) {
+		} else if (blocksize < psector_size) {		/* Suboptimal */
 			fprintf(stderr, _("Warning: specified blocksize %d is "
-				"less than device physical sectorsize %d, "
-				"forced to continue\n"), blocksize,
-				psector_size);
+				"less than device physical sectorsize %d\n")
+				blocksize, psector_size);
 		}
 	}
 

-Eric


