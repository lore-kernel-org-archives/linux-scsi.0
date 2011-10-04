From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH 04/13] qla4xxx: Do not add duplicate CHAP entry in FLASH
Date: Tue, 4 Oct 2011 10:13:12 -0700
Message-ID: <CAB07E7A.98F9%vikas.chaudhary@qlogic.com>
References: <4E8A1E13.90401@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:28397
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754644Ab1JDRNS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Oct 2011 13:13:18 -0400
In-Reply-To: <4E8A1E13.90401@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>



On 03/10/11 1:41 PM, "Mike Christie" <michaelc@cs.wisc.edu> wrote:

>On 10/03/2011 03:40 PM, Mike Christie wrote:
>> On 10/03/2011 12:29 PM, vikas.chaudhary@qlogic.com wrote:
>>> From: Lalit Chandivade <lalit.chandivade@qlogic.com>
>>>
>>> QLogic applications store the CHAP information in FLASH. During login,
>>> authentication information is provided using an index into the CHAP
>>>region.
>>>
>>> In order to support QLogic applications along with iscsiadm, updated
>>>the
>>> LLD to not add duplicate CHAP entries in the CHAP region and preserve
>>>the
>>> existing CHAP info in the CHAP region in FLASH.
>>> This allows QLogic applications to pre-write the CHAP entries in the
>>>CHAP
>>> region.
>>>
>>> With iscsiadm, when the CHAP authentication information is sent to the
>>>LLD, the
>>> LLD searches for the entry in CHAP region in FLASH, if exists then do
>>>not add.
>>> If CHAP entry does not exist then add the CHAP entry in the CHAP
>>>region.
>>>
>>
>> Does the qlogic app use the bsg flash commands to send down everything
>> then or how does one app work differently and use the same driver for
>> everything else?

Yes, QLogic app will use BSG flash to write to the CHAP table in FLASH.
For isciadm, LLD would check if CHAP entry is present in the FLASH and
if not then add it to the FLASH. The difference between QLogic app and
iscsiadm would be the delete part. Going forward we would need
A way to delete the CHAP entries from FLASH using iscsiadm.


>>
>
>Or does the the qlogic app store the targets in flash too or just the
>chap info?

Target info for boot target only is stored in the FLASH. All other
targets are not stored in FLASH.
And also CHAP table is stored in FLASH since firmware while doing
CHAP authentication uses the index into CHAP table to find the
user/secret information.



This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

