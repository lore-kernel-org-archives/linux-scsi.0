From: Krishna Murthy <krmurthy@cisco.com>
Subject: Re: scsi_scan_target and SCSI_2
Date: Thu, 27 Nov 2003 21:15:28 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200311272115.28094.krmurthy@cisco.com>
References: <200311252037.34015.krmurthy@cisco.com> <200311271849.15241.krmurthy@cisco.com> <1069947459.1837.28.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:19092 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S264544AbTK0Pqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Nov 2003 10:46:48 -0500
In-Reply-To: <1069947459.1837.28.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

Hi,
	What I intended to say was in case we get 3 as the peripheral qualifier
in response to inquiry on lun 0, shouldn't we use the scsi level as returned 
in inquiry response instead of using a a default scsi level of SCSI_2.

Thanx
N.C.Krishna Murthy
On Thursday 27 Nov 2003 9:07 pm, James Bottomley wrote:
> On Thu, 2003-11-27 at 07:19, Krishna Murthy wrote:
> > scsi_probe_and_add_lun() calls scsi_probe_lun(). In case there is no lun
> > 0 then the information about scsi_level is lost.
>
> SAM-3 in section 4.9.2 begins "All SCSI devices shall accept LUN 0 as a
> valid address...".
>
> This requirement is in SCSI-2 as well.
>
> If your implementation doesn't do this, I suggest you fix it.
>
> If lun 0 responds (as it is required by the standards to do), but shows
> only a perfunctory standards conforming response indicating it's not
> really present, we scan, and the scsi_level will be recorded for each
> correctly scanned lun.
>
> > We now call scsi_sequential_lun_scan() with BLIST_SPARSELUN,SCSI_2 as
> > parameters, which instead should have been bflags,scsi_level as
> > determined by scsi_probe_lun.
> >
> > Isn't this is  a bug? Please let me know if I am missing something.
>
> No, it's deliberate.  Whether we should do this is open to debate, but
> there's a comment in the code explaining the logic:
>
> 		/*
> 		 * There's a target here, but lun 0 is offline so we
> 		 * can't use the report_lun scan.  Fall back to a
> 		 * sequential lun scan with a bflags of SPARSELUN and
> 		 * a default scsi level of SCSI_2
> 		 */
>
> James
