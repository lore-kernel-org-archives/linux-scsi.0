From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: EMCCTD kernel driver Patch for review
Date: Mon, 11 Jan 2016 03:05:48 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB4450A204@G9W0766.americas.hpqcorp.net>
References: <82807C73E0BDBB498164AAE7B8F6A1481C6055F9@MX105CL01.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <82807C73E0BDBB498164AAE7B8F6A1481C6055F9@MX105CL01.corp.emc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Singhal, Maneesh" <Maneesh.Singhal@emc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "JBottomley@odin.com" <JBottomley@odin.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Can I make some suggestions:

1) Include linux-api in the review or your new driver - you're creating new files in /proc and there's a good chance you'll get told that isn't going to be allowed. 
2) With this comment in the source:

+ *        DO NOT MODIFY ANY DATA STRUCTURES IN THIS FILE WITHOUT CONSULTING THE
+ *        GUEST OS GROUP!

How would someone do that? If someone really wanted to change a structure and others (outside of EMC) and had really good reasons for doing so I don't think you can really stop someone from doing it (as much as you may not like it). You might try something less direct like "Before modifying any data structures in this file please discuss the change with the EMC Guest OS group" and say if the maintainers email address should be used or something else. 

3) The patch doesn't patch the MAINTAINERS file to indicate who is the maintainer for the driver
4) Have you run it through checkpatch.pl? It should be producing no warnings or errors (that cannot be justified). I would have expected it to have triggered the following warning multiple times at the very least (since there's an overabundance of LINUX_VERSION_CODE in the patch):

# avoid LINUX_VERSION_CODE
		if ($line =~ /\bLINUX_VERSION_CODE\b/) {
			WARN("LINUX_VERSION_CODE",
			     "LINUX_VERSION_CODE should be avoided, code should be for the version to which it is merged\n" . $herecurr);
		}

I know I stopped looking at anything after seeing lots of #ifdefs containing LINUX_VERSION_CODE.

5) What about any relevant documentation for the driver under the Documentation directory (if you switch to sysfs you will need to create documentation for every new file you create in sysfs describing what it is).
6) Read all of: https://www.kernel.org/doc/Documentation/SubmittingPatches - running checkpatch.pl is covered as is number 6 - no attachments (you are probably lucky if anyone apart from me opened it). Your email should have started with [PATCH] in the subject - without that it may get lost of the mailing list and nobody may read it.

Consider addressing all of these. I doubt that you'll get much interest in terms of reviews until you do so.

Thanks
Shane
