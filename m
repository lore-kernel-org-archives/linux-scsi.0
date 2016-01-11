From: "Singhal, Maneesh" <Maneesh.Singhal@emc.com>
Subject: RE: EMCCTD kernel driver Patch for review
Date: Mon, 11 Jan 2016 09:56:42 +0000
Message-ID: <82807C73E0BDBB498164AAE7B8F6A1481C6082E4@MX105CL01.corp.emc.com>
References: <82807C73E0BDBB498164AAE7B8F6A1481C6055F9@MX105CL01.corp.emc.com>
 <DDB9C85B850785449757F9914A034FCB4450A204@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "JBottomley@odin.com" <JBottomley@odin.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Hello Shane,

Thanks for the quick review. Please find my replies below:
 
> > -----Original Message-----
> > From: Seymour, Shane M [mailto:shane.seymour@hpe.com]
> > Sent: Monday, January 11, 2016 8:36 AM
> > To: Singhal, Maneesh; linux-scsi@vger.kernel.org; linux-
> > kernel@vger.kernel.org; JBottomley@odin.com;
> > martin.petersen@oracle.com
> > Subject: RE: EMCCTD kernel driver Patch for review
> >
> > Can I make some suggestions:
> >
> > 1) Include linux-api in the review or your new driver - you're
> > creating new files in /proc and there's a good chance you'll get told
> > that isn't going to be allowed.
> [MS>] I will do that.
> > 2) With this comment in the source:
> >
> > + *        DO NOT MODIFY ANY DATA STRUCTURES IN THIS FILE
> WITHOUT
> > CONSULTING THE
> > + *        GUEST OS GROUP!
> >
> > How would someone do that? If someone really wanted to change a
> > structure and others (outside of EMC) and had really good reasons
> for
> > doing so I don't think you can really stop someone from doing it (as
> > much as you may not like it). You might try something less direct like
> > "Before modifying any data structures in this file please discuss the
> > change with the EMC Guest OS group" and say if the maintainers
> email
> > address should be used or something else.
> >
> [MS>] I agree. Will remove the comment.
> 
> > 3) The patch doesn't patch the MAINTAINERS file to indicate who is
> the
> > maintainer for the driver
> [MS>] Will add
> > 4) Have you run it through checkpatch.pl? It should be producing no
> > warnings or errors (that cannot be justified). I would have expected
> > it to have triggered the following warning multiple times at the very
> > least (since there's an overabundance of LINUX_VERSION_CODE in
> the
> > patch):
> >
> > # avoid LINUX_VERSION_CODE
> > 		if ($line =~ /\bLINUX_VERSION_CODE\b/) {
> > 			WARN("LINUX_VERSION_CODE",
> > 			     "LINUX_VERSION_CODE should be avoided,
> code should be for the
> > version to which it is merged\n" . $herecurr);
> > 		}
> >
> > I know I stopped looking at anything after seeing lots of #ifdefs
> > containing LINUX_VERSION_CODE.
> >
> [MS>] I did run checkpatch.pl. And yes, there are many warnings as
> well. About VERSION_CODE warning, we actually have to run driver for
> multiple kernel versions, so does this mean that I submit the patch
> only for current or latest kernel version, and maintain a local copy of
> driver for all other versions ?
> 
> > 5) What about any relevant documentation for the driver under the
> > Documentation directory (if you switch to sysfs you will need to
> > create documentation for every new file you create in sysfs
> describing
> > what it is).
> [MS>] Will add.
> > 6) Read all of:
> > https://www.kernel.org/doc/Documentation/SubmittingPatches -
> running
> > checkpatch.pl is covered as is number 6 - no attachments (you are
> > probably lucky if anyone apart from me opened it). Your email should
> > have started with [PATCH] in the subject - without that it may get
> > lost of the mailing list and nobody may read it.
> [MS>] Sure. Will check all of them again, and resubmit the patch. Can
> you please help me on answering the VERSION_CODE thingy.
> >
> > Consider addressing all of these. I doubt that you'll get much
> > interest in terms of reviews until you do so.
> >
> > Thanks
> > Shane
