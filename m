From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Unique numeric ID for SCSI-3 disks
Date: Fri, 09 Dec 2011 12:34:23 -0500
Message-ID: <4EE2469F.606@interlog.com>
References: <E4D7778E36CF944ABD2F7E18D2DB9666271BAC7FBF@inbmail02.lsi.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:49658 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab1LIRfO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Dec 2011 12:35:14 -0500
In-Reply-To: <E4D7778E36CF944ABD2F7E18D2DB9666271BAC7FBF@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Sampathkumar, Kishore" <Kishore.SampathKumar@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 11-12-05 03:33 AM, Sampathkumar, Kishore wrote:
> In SCSI-3 SPC, I was going through the section on "Device Identification VPD Page" (Section 7.6.3). I see the following:
>
> If "Association" field in VPD83 page is set to 00b (i.e., The IDENTIFIER field is associated with the addressed logical unit), the above standard says:
>
> At least one identification descriptor should have the IDENTIFIER TYPE field set to:
> a) 2h (i.e., EUI-64-based);
> b) 3h (i.e., NAA); or
> c) 8h (i.e., SCSI name string).
>
> Going through the details of (a) and (b), I notice that they are numeric.
>
> However, (c) above is an ASCII string. But, even in this case, if the first 4 UTF-8 characters are parsed, the rest of it contains numeric value in ASCII.
>
> For all SCSI disks that are SCSI-3 SPC compliant, for the above case, is it safe to say: each of them shall have an associated "numeric value" that is "unique" (assuming that the 4 UTF-8 characters for "SCSI name string" format are stored/available).

"Logical Unit name" is the most recent t10.org term to
describe the "designator" (no longer called "identifier")
whose association is 00b in the Device Identification
VPD page (83h).

SCSI transport standards say very little about Logical
Unit (LU) names. For example SPL-2 (SAS) says the LU name
should be different from the target port identifiers and
target device name of the device (disk) that contains the
LU. In other words there are 3 NAA-5 values that the LU
name of a SAS disk can _not_ be.

You have found what SPC-3 (and SPC-4) says about LU names. That
is it, nothing else. In SPC-4 the definition of a SCSI name
string for a lead-in of ".iqn" (as used by iSCSI) breaks
your assertion:

"If the ASSOCIATION field is set to 00b (i.e., logical unit) and
the SCSI NAME STRING field starts with the four UTF-8 characters
'iqn.', the SCSI NAME STRING field ends with the five UTF-8
characters ',L,0x' concatenated with 16 hexadecimal digits for
the logical unit name extension. The logical unit name extension
is a UTF-8 string containing no more than 16 hexadecimal digits.
The logical unit name extension is assigned by the SCSI target
device vendor and shall be assigned so the logical unit name is
worldwide unique."

Unlikely but possible is that a SAS fabric has a SAS to iSCSI
bridge located behind a SAS target so any LUs behind that
bridge are in a iSCSI domain. Such iSCSI LUs would most likely
follow iSCSI LU naming conventions. So a SAS application client
running on Linux could see a LU name like this:
   "iqn.2001-04.com.example,L,0x0000000000000000"

Doug Gilbert



