From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH] iscsi: respond to netlink with unicast when appropriate
Date: Mon, 9 Apr 2018 16:03:33 -0700
Message-ID: <a75c870a-6189-3982-d2bd-2199362a3c61@suse.com>
References: <20180409221528.67880-1-cleech@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180409221528.67880-1-cleech@redhat.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Chris Leech <cleech@redhat.com>, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On 04/09/2018 03:15 PM, Chris Leech wrote:
> Instead of always multicasting responses, send a unicast netlink message
> directed at the correct pid.  This will be needed if we ever want to
> support multiple userspace processes interacting with the kernel over
> iSCSI netlink simultaneously.  Limitations can currently be seen if you
> attempt to run multiple iscsistart commands in parallel.
> 
> We've fixed up the userspace issues in iscsistart that prevented
> multiple instances from running, so now attempts to speed up booting by
> bringing up multiple iscsi sessions at once in the initramfs are just
> running into misrouted responses that this fixes.

As you may know, I disagree with running multiple iscsistart-s at the
same time, since that's what iscsid is for.

Never the less, I believe we _should_ be able to have multiple processes
talking to the kernel target code, so I agree with these changes.

> 
> Signed-off-by: Chris Leech <cleech@redhat.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
> 
> ... (diffs removed to save electrons)
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>
-- 
Lee Duncan
SUSE Labs
