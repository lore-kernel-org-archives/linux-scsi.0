From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: mpt2sas: /sysfs sas_address entries do not show individual port
 sas addresses.
Date: Thu, 18 Aug 2011 15:52:24 -0400
Message-ID: <4E4D6D78.6040106@interlog.com>
References: <4E4B9B04.10302@mpstor.com> <4E4BDFD7.3060109@interlog.com> <4E4D529F.9090908@oracle.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:59714 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab1HRUmb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Aug 2011 16:42:31 -0400
In-Reply-To: <4E4D529F.9090908@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Shankar <ravi.v.shankar@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 11-08-18 01:57 PM, Ravi Shankar wrote:
>
>>
>>
>> Do you know a reason why it is not preferably for every
>> phy on a SAS HBA to respond with the same SAS address?
>>
>>
>> As a practical matter a SAS HBA needs a single SAS address,
>> preferably printed on the board or its box. Then if you
>> manage to wipe its SAS address (e.g. by erasing its flash
>> to move from IR to IT firmware) then you know which SAS
>> address to re-instate :-)
>>
> HBA SAS phy could have same SAS address when they are directly connected.
> however when connected to expanders, each logical port/phy need unique SAS
> address.

No.

SAS HBAs and expanders should always be trying to maximize
the width of a link. By definition all physical ** phys on an
expander should (must) have the same SAS address. So if
you connect 5 phys from a SAS HBA to the same expander (and
the HBA supports links wider than 4 phys) then those
5 HBA phys should have the same SAS address. Those 5 HBA
phys then form a SCSI port.

Just tested a triangular arrangement: a LSI SAS-2 HBA
(9212-4i4e) connected to one SAS-2 expander (4 phy wide link)
and one SAS-1 expander (narrow link). And the expanders
where connected to each other. Two disks were connected
to the SAS-2 expander.
Both expanders reported the same SAS address for the
5 HBA attached phys. You might argue that is two
separate SCSI initiator ports with the same port
identifier (SAS address) in the same SAS domain.

Anyway there was an interesting difference between the HBA's
BIOS and Linux (lk 3.0.3): the BIOS reported those two
disks twice while Linux only reported them once. That seems
to suggest that the BIOS set up the routing table in the
SAS-1 expander while Linux did not. smp_discover in Linux
confirms that the SAS-1 expander's route table was not set up.

The trouble with testing is that is raises more questions
than it supplies answers.


SAS disks have two phys which are typically given two
different SAS addresses. This stops them forming a wide link
if, for example, they were both connected to the same
expander. Typically the two SAS disk phys would be connected
to different expanders for redundancy. However if the
interest was speed (e.g. with a SAS SSD) then both the
disk phys might be given the same SAS address.


** SAS-2 expanders often have an integrated SES target
    on a virtual phy in the expander chip, and that
    virtual phy has a different SAS address.

Doug Gilbert


P.S. Why is my post cc-ing to "unlisted-recipients:;"

