From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH 10/11] qla4xxx: Added ping support
Date: Tue, 6 Mar 2012 04:26:45 -0800
Message-ID: <CB7BFAFA.D267%vikas.chaudhary@qlogic.com>
References: <4F557B41.5010703@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:1924 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030429Ab2CFM0w convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Mar 2012 07:26:52 -0500
In-Reply-To: <4F557B41.5010703@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>



-----Original Message-----
From: Mike Christie <michaelc@cs.wisc.edu>
Date: Mon, 5 Mar 2012 18:49:37 -0800
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, scsi
<linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>, Lalit
Chandivade <lalit.chandivade@qlogic.com>
Subject: Re: [PATCH 10/11] qla4xxx: Added ping support

>On 02/13/2012 07:00 AM, vikas.chaudhary@qlogic.com wrote:
>> +
>> +            if (mbox_sts_entry->out_mbox[0] == MBOX_STS_COMMAND_COMPLETE)
>> +                    status = QLA_SUCCESS;
>> +            else
>> +                    status = QLA_ERROR;
>> +
>> +            data_size = sizeof(mbox_sts_entry->out_mbox);
>> +
>> +            qla4xxx_post_ping_evt_work(ha, status, mrb->pid, data_size,
>> +                                    (uint8_t *) mbox_sts_entry->out_mbox);
>> +            break;
>> +
>
>Not sure what I was thinking. This is not going to work.
>
>We are not going to pass back vendor specific values, and then have
>multiple decoders in userspace.
>
>What are you trying to pass back up to userspace? Can you add a enum or
>defines for some common error values? We can also pass back vendor
>specific info, but we have to also have some common error cls info or it
>is completely useless to other apps.
>
>And, can we get more info that if it failed or not?

I modified code to return detail error code that other vendors can also
use.
I am sending patch for same in next email.


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

