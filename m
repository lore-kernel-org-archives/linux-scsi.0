From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 08/16] scsi_dh_alua: parse target device id
Date: Mon, 17 Feb 2014 15:05:14 +0100
Message-ID: <5302171A.9070507@acm.org>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-9-git-send-email-hare@suse.de> <52FE0793.9040505@acm.org> <52FE0A66.6050200@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.65]:39545 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751516AbaBQOFS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Feb 2014 09:05:18 -0500
In-Reply-To: <52FE0A66.6050200@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 02/14/14 13:21, Hannes Reinecke wrote:
> On 02/14/2014 01:09 PM, Bart Van Assche wrote:
>> On 01/31/14 10:29, Hannes Reinecke wrote:
>>> +	if (!target_id_size) {
>>> +		/* Check for EMC Clariion extended inquiry */
>>> +		if (!strncmp(sdev->vendor, "DGC     ", 8) &&
>>> +		    sdev->inquiry_len > 160) {
>>> +			target_id_size = sdev->inquiry[160];
>>> +			target_id = sdev->inquiry + 161;
>>> +			strcpy(target_id_str, "emc.");
>>> +			memcpy(target_id_str + 4, target_id, target_id_size);
>>> +		}
>>> +		/* Check for HP EVA extended inquiry */
>>> +		if (!strncmp(sdev->vendor, "HP      ", 8) &&
>>> +		    !strncmp(sdev->model, "HSV", 3) &&
>>> +		    sdev->inquiry_len > 170) {
>>> +			target_id_size = 16;
>>> +			target_id = sdev->inquiry + 154;
>>> +			strcpy(target_id_str, "naa.");
>>> +			memcpy(target_id_str + 4, target_id, target_id_size);
>>> +		}
>>> +	}
>>
>> Being able to identify a storage array unambiguously is essential for
>> the new ALUA device handler algorithm introduced by this patch series.
>> What if a new storage array is introduced that is not covered by one of
>> the heuristics in this patch ? Has it been considered to let storage
>> array identification occur in user space instead of in the kernel ?
>
> As noted in the other mail, if we cannot decipher the array
> identifier the whole thing degrades into one pg per sdev.
> IE we cannot bunch RTPG / STPG for those.
> The idea here is that those arrays do not have any limitations,
> so that no special treatment is required.
> 
> Adding identifiers from userspace are a bit tricky; there is no
> actual sysfs structure for the device handler.
> Which we would need if we were to use these tricks.

The reason I started asking about the target device ID is because for
Fusion-io ION devices we also encode the device ID in the INQUIRY
response (bytes 36..55; left aligned; padded with '\0'). The vendor name
is "FUSIONIO" and the first three characters of the product name are
"ION". Can you add  the necessary support in the device identification
code ? Seems like it's time we get you a pair of those devices for
testing :-) An example:

# sg_inq -rl256 /dev/sdb | dd bs=1 count=20 skip=36 2>/dev/null | od -c
0000000   U   S   E   2   4   0   F   W   6   5  \0  \0  \0  \0  \0  \0
0000020  \0  \0  \0  \0
0000024

Thanks,

Bart.

