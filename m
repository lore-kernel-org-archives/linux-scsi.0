From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: Re: [PATCH 2/3] - mpt fusion -
Date: Thu, 13 Apr 2006 20:14:41 -0600
Message-ID: <002c01c65f69$319745c0$201015ac@ericmoore>
References: <664A4EBB07F29743873A87CF62C26D70080B51@NAMAIL4.ad.lsil.com> <20060414010405.GB23580@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:51953 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S965073AbWDNCOj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 22:14:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Thursday, April 13, 2006 7:04 PM, Christoph Hellwig wrote:

>> 
>> I'll explain the problem.
>> The sas drivers have a rphy to rphy relationship.  An rphy
>> created on a hba phy points to the expander phy.  Then the expander
>> phy creates a rphy pointing back to the same hba rphy. The expander
>> phy which contains the rphy pointing back to the hba phy, contains
>> the attributes device_type = SAS_END_DEVICE, and target_port_protocals =
>> 0.
>> Hence the recent change in sas_rphy_add() make it drop down to
>> scsi_scan_target, whereas before there was sepecial handling to 
>> prevent this case from happening.  With this change, the mptsas slave
>> entry 
>> points are called to enumerate the rphy that points back to the hba phy.
>> The target id in our data structures is the same as a real target device
>> on another phy.  Thus we end up mapping the same target to two different
>> rphys.
>> To fix this, I added a check in mptsas_slave_alloc to make sure the
>> requested rphy is mapped to a true end device.
> 
> This needs to be fixed in the transport class again.
> 

Christoph can you help me on this, please?
The original sas_rphy_add() function from three weeks back works for mptsas.
I'm not sure why that change was made, and whether reverting back to its orginal code
would break the other sas driver.  

Eric


