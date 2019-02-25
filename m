From: Lee Duncan <lduncan@suse.com>
Subject: Re: [RESEND] [PATCH] Hold back_lock when calling iscsi_complete_task
Date: Mon, 25 Feb 2019 09:39:04 -0800
Message-ID: <977e50ae-7623-65ce-8851-154026f63f2d@suse.com>
References: <20190222162947.25178-1-leeman.duncan@gmail.com>
 <594d8ad8-78d1-e012-d782-39abb746032b@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <594d8ad8-78d1-e012-d782-39abb746032b@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, cleech@redhat.com
Cc: hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On 2/25/19 2:02 AM, Johannes Thumshirn wrote:
> On 22/02/2019 17:29, Lee Duncan wrote:
>> From: Lee Duncan <lduncan@suse.com>
>>
>> If there is an error queueing an iscsi command in
>> iscsi_queuecommand(), for example if the transport fails
>> to take the command in sessuin->tt->xmit_task(), then
>> the error path can call iscsi_complete_task() without
>> first aquiring the back_lock as required. This can
>> lead to things like ITT pool can get corrupt, resulting
>> in duplicate ITTs being sent out.
>>
>> The solution is to hold the back_lock around
>> iscsi_complete_task() calls, and to add a little commenting
>> to help others understand when back_lock must be held.
> 
> You're missing a S-o-b here.
> 
> Byte,
> 	Johannes
> 

Doh!

I will resend.

-- 
The Lee-Man
