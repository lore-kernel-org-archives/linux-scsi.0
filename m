From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: Compaq Fiber Channel Array RM4000 / SCSI Problems / Need HELP!
Date: Wed, 29 Mar 2006 01:07:25 -0500
Message-ID: <yq18xqtain6.fsf@wilson.lab.mkp.net>
References: <Pine.GSO.4.64.0602250050410.27649@filebunker.xip.at>
	<Pine.GSO.4.64.0602280120290.25994@filebunker.xip.at>
	<Pine.GSO.4.64.0602280130320.25994@filebunker.xip.at>
	<20060228004043.GH27759@parisc-linux.org>
	<Pine.GSO.4.64.0603221911370.14214@filebunker.xip.at>
	<yq1lkv2iap8.fsf@wilson.lab.mkp.net>
	<Pine.GSO.4.64.0603222054520.14214@filebunker.xip.at>
	<20060322200229.GT8980@parisc-linux.org>
	<Pine.GSO.4.64.0603222105560.14214@filebunker.xip.at>
	<Pine.GSO.4.64.0603282134370.8439@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:2998 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S1751087AbWC2GHe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 01:07:34 -0500
In-Reply-To: <Pine.GSO.4.64.0603282134370.8439@filebunker.xip.at> (Ingo Flaschberger's message of "Tue, 28 Mar 2006 21:43:32 +0200 (CEST)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Flaschberger <if@xip.at>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

>>>>> "Ingo" == Ingo Flaschberger <if@xip.at> writes:

Ingo> I'm now diging since one week in the scsi code and get no idea
Ingo> what fails.  I have, when I dd more the 556K to an ext3 at sda1,
Ingo> an "Illegal Request"; "Invalid field in cdb"

I'm sorry I'm completely and utterly swamped right now - dealing with
a slipped product release schedule.

If I read your code correctly last week, all you've done so far is
mess with LUN scanning.  And my guess is things blow up when you've
queued enough I/O and things start actually hitting the metal.

The real problem with the RA4100 is that you can't just send commands
(cdbs) to it directly.  You need to mangle them and this is what we
currently have no good infrastructure to support.

The RA4100 supports two addressing modes VSA and PDA and depending on
which mode is used you need to mangle the cdb in different ways.
Judging from the comments in cpqfc it appears the mode depends on the
firmware of the RA4100 in question.

Below is what I sent to hch about the RA4100 a while ago...

Btw. SCC is the SCSI Controller Commands specification -
i.e. TYPE_RAID.  The spec is at

     http://www.t10.org/ftp/t10/drafts/scc2/scc2r04.pdf

---8<---

The LUN mangling takes place in cpqfcTSworker.c.  Here's what happens:

 - IssueReportLunsCommand() gets fired off to send a REPORT_LUNS to
   the array SCSI ID.

 - ScsiReportLunsDone() is called upon completion.  If REPORT_LUNS
   failed we need to use peripheral device addressing (PDA) and set
   VolumeSetAddressing (VSA) to 0.

   If REPORT_LUNS succeeded VSA is set to 1 and so is LunMasking
   (which is a kludge becase we didn't do sparse LUNs).

 - fcFindLoggedInPort() is a swiss army knife function that gets
   called all over the place in cpqfc.  It deals with mappings between
   WWNs/port ids and SCSI channel/target/lun tuples.  In this case we
   need to map a Linux LUN to a fibre channel ID (AL_PA or WWN)

   Look for /* This is not passthrough */ in that function:

   The Scsi_Cmnd in transit has a few things changed.  Specifically,
   the scratch pad is abused:

   - Cmnd->SCp.phase is set to contain either PDA or VSA

   - Cmnd->SCp.Message is set to contain the device type snooped from
     INQUIRY (check out cpqfcTSCheckandSnoopFCP())

   - Cmnd->SCp.have_data_in is set to the real LUN

   So far so good.  Now we've got some extra fluff in the Cmnd.  On
   to...

 - build_FCP_payload() which picks these pieces out of the supplied
   Cmnd and builds an FCP transfer with the SCC addressing gunk
   prepended to the cdb.

Now, all the sparse LUN stiff is obsolete.  And the only place the
stored inquiry data is being used is to special case timeouts when
dealing with tape devices.

So the only state we need to keep is the real LUN # and the addressing
mode (VSA or PDA are probably the only relevant ones).  Given that we
can use the LUN value directly, all we need to do is to get the
addressing blah prepended.

---8<---

-- 
Martin K. Petersen      http://mkp.net/
