From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH] scsi_debug: rework resp_report_luns
Date: Wed, 25 Feb 2015 18:10:28 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B34BB6352@HASMSX106.ger.corp.intel.com>
References: <1424813825-1970-1-git-send-email-tomas.winkler@intel.com>
 <54ED0C56.7040900@interlog.com>
 <5B8DA87D05A7694D9FA63FD143655C1B34BB49C6@HASMSX106.ger.corp.intel.com>
 <54EDF6BE.2030000@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:7752 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbbBYSKd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Feb 2015 13:10:33 -0500
In-Reply-To: <54EDF6BE.2030000@interlog.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>, "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Elliott, Robert (Server Storage)" <elliott@hp.com>

> Correct, so if the app client sets an allocation length
> of 3, then at your discretion, you can either leave the
> code doing what it does now, or return those 3 bytes.
> IOW leave it alone, improve it but don't make it worse.

Ack, got the new spec and looks like the check < 4 is the correct one as we cannot fulfill the command in less than ten 

'4.2.5.6 Allocation length
 If the amount of information that is available to be transferred exceeds the maximum value that the
ALLOCATION LENGTH field in combination with other fields in the CDB is capable of specifying, then no data
shall be transferred and the command shall be terminated with CHECK CONDITION status, with the sense
key set to ILLEGAL REQUEST, and the additional sense code set to INVALID FIELD IN CDB.
'
The only special case that needs to be taken care of is check for == 0 which is not an error... just do not return anything? 

> 
> I was noting that the boundary specified by the allocation
> length (e.g. 3 or 11) may be an awkward fit for the loop
> logic. For example you can't unconditionally use
> put_unaligned_be32() into the response buffer if it was
> kmalloc-ed for an allocation length of 3 bytes.

That would not happen as we got out on < 4 and we use those 4 bytes to write the LUN LIST LENGTH 
Strangely the original code also ignored the allocation length from the request command and dumped whatever is available up to  SDEBUG_RLUN_ARR_SZ
That can be fixed too tough there some vague sentence: 
'The contents of the LUN LIST LENGTH field
are not altered based on the allocation length (see 4.2.5.6).'
 
Tomas

