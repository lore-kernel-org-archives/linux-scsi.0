From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 1/1] libfc: fix queue command rport checks
Date: Wed, 16 Jul 2008 13:56:03 -0500
Message-ID: <487E4443.7090601@cs.wisc.edu>
References: <1216234249-10812-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1216234249-10812-1-git-send-email-michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org wrote:
> 4. fc_lport_destroy, fc_fcp_destroy ordering in fcoe_destroy_interface does
> not seem right. It looks like if we need to send a sync cache to the device
> when it is removed it will always fail.
>

Oh yeah, I ccd linux-scsi for this patch and not others, because JamesS 
and them are not on fcoe devel list, and it seems like all fc drivers 
fail the sync cache command.

What happens is that we remove the rport which sets the rport state, 
then the fc class removes the target. This causes the target and its 
devices to be removed, which can cause a sync cache to be sent. But 
because the the rport is not in the online state it will fail the command.
