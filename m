From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [RESEND] [PATCH] Hold back_lock when calling iscsi_complete_task
Date: Mon, 25 Feb 2019 11:02:25 +0100
Message-ID: <594d8ad8-78d1-e012-d782-39abb746032b@suse.de>
References: <20190222162947.25178-1-leeman.duncan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190222162947.25178-1-leeman.duncan@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, cleech@redhat.com
Cc: hare@suse.de, Lee Duncan <lduncan@suse.com>
List-Id: linux-scsi@vger.kernel.org

On 22/02/2019 17:29, Lee Duncan wrote:
> From: Lee Duncan <lduncan@suse.com>
> 
> If there is an error queueing an iscsi command in
> iscsi_queuecommand(), for example if the transport fails
> to take the command in sessuin->tt->xmit_task(), then
> the error path can call iscsi_complete_task() without
> first aquiring the back_lock as required. This can
> lead to things like ITT pool can get corrupt, resulting
> in duplicate ITTs being sent out.
> 
> The solution is to hold the back_lock around
> iscsi_complete_task() calls, and to add a little commenting
> to help others understand when back_lock must be held.

You're missing a S-o-b here.

Byte,
	Johannes
-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
