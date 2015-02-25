From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH] scsi_debug: rework resp_report_luns
Date: Wed, 25 Feb 2015 17:01:22 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295A7D0002@G9W0745.americas.hpqcorp.net>
References: <1424813825-1970-1-git-send-email-tomas.winkler@intel.com>
 <54ED0C56.7040900@interlog.com>
 <5B8DA87D05A7694D9FA63FD143655C1B34BB49C6@HASMSX106.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:32933 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbbBYRCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Feb 2015 12:02:04 -0500
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B34BB49C6@HASMSX106.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Winkler, Tomas
> Sent: Wednesday, February 25, 2015 1:54 AM
> To: dgilbert@interlog.com; James E.J. Bottomley"
> Cc: linux-scsi@vger.kernel.org
> Subject: RE: [PATCH] scsi_debug: rework resp_report_luns
> 
> > On 15-02-24 04:37 PM, Tomas Winkler wrote:
> > > 1. Fix the error check: the alloc length should be > 16
> > > and not > 4
> >
> > You are proposing to make a marginally incorrect test
> > completely incorrect!
> 
> Quoting from the spec:
> The ALLOCATION LENGTH field is defined in 2.2.6. The allocation length
> should be at least 16.
> Note. Device servers compliant with SPC return CHECK CONDITION status,
> with the sense key set to ILLEGAL REQUEST, and the additional sense code
> set to INVALID FIELD IN CDB when the allocation length is less than 16 bytes.
> This is how it is implemented also in other drivers in the scsi drivers.

That was just a warning to software that very old devices (compliant with SPC-1)
returned CHECK CONDITION in that case, explaining why the "should" advice
is included.  New devices (SPC-2 and later) are not supposed to return
CHECK CONDITION.  "SPC" means SPC-1 only, not all versions.  This
warning note was in SPC-2 and SPC-3 and dropped in SPC-4.


