From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] SCSI core: always store >= 36 bytes of INQUIRY data
Date: Fri, 27 Oct 2006 18:10:58 -0400
Message-ID: <454283F2.3090809@torque.net>
References: <Pine.LNX.4.44L0.0610261709360.9684-100000@iolanthe.rowland.org> <20061027214343.GA1701@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:3559 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750764AbWJ0WKE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Oct 2006 18:10:04 -0400
In-Reply-To: <20061027214343.GA1701@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Patrick Mansfield wrote:
> On Thu, Oct 26, 2006 at 05:11:27PM -0400, Alan Stern wrote:
>> This patch (as810) sets the length of the INQUIRY data to a minimum of
>> 36 bytes, even if the device claims that not all of them are valid.
>> Using the data sent by the device is better than allocating a short
>> buffer and then reading beyond the end of it, which is what we do now.
>>
>> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
>>
>> ---
>>
>> Index: usb-2.6/drivers/scsi/scsi_scan.c
>> ===================================================================
>> --- usb-2.6.orig/drivers/scsi/scsi_scan.c
>> +++ usb-2.6/drivers/scsi/scsi_scan.c
>> @@ -575,6 +575,19 @@ static int scsi_probe_lun(struct scsi_de
>>  	 * short INQUIRY), an abort here prevents any further use of the
>>  	 * device, including spin up.
>>  	 *
>> +	 * On the whole, the best approach seems to be to assume the first
>> +	 * 36 bytes are valid no matter what the device says.  That's
> 
> The comment is confusing, as it implies the device will modify data past
> the indicated length, but well behaved devices should not do that, and
> with your patch should point to zero filled data.
> 
> Just comment on what its avoiding or such like:
> 
> 	Modify short inquiry_len values so we don't later point at random
> 	values. Devices returning an incorrect value in the INQUIRY
> 	additional length field will point at potentially valid data for
> 	Vendor, Product and Revsion, while conforming devices will point
> 	to zero filled data.
> 
> But definitely better to use possibly valid data for broken devices or
> NUL for well behaved devices rather than garbage values.
> 
>> +	 * better than copying < 36 bytes to the inquiry-result buffer
>> +	 * and displaying garbage for the Vendor, Product, and Revision
>> +	 * strings.
>> +	 */
>> +	if (sdev->inquiry_len < 36) {
>> +		printk(KERN_INFO "scsi scan: INQUIRY result too short (%d),"
>> +				" using 36\n", sdev->inquiry_len);
>> +		sdev->inquiry_len = 36;
>> +	}
>> +
>> +	/*

Some more information on this subject: LLDs (including
pseudo ones like usb-storage) really should set the
Scsi_Cmnd::resid field to show, in the case of an
INQUIRY, when 36 bytes were requested, less bytes
were returned.

That OS from Redmond may have a hand here as well.
Directly attached ATA disks are found in SCSI scans and
respond to SCSI INQUIRY commands with plausible vendor,
model and revision strings but the additional length
field (byte 4 in the response) is set to 0. So code
could use that as a hint to stop sending further SCSI
commands and start sending ATA commands. ATA disks
behind USB and IEEE 1394 don't appear in SCSI scans
but do appear as "Physical Drives" and do respond
to SCSI INQUIRY commands properly. Then there are
ATA disks behind a SATL and they respond to SCSI
INQUIRY commands (and most others) properly; the
easiest way to spot them is that the vendor is "ATA     ".

Doug Gilbert


