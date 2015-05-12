From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH] iscsi_ibft: filter null v4-mapped v6 addresses
Date: Mon, 11 May 2015 19:07:54 -0500
Message-ID: <5551445A.2050103@cs.wisc.edu>
References: <1431062071-7074-1-git-send-email-cleech@redhat.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBCZ4TFNN2YMRBYMIYWVAKGQEMMEZ67Y-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1431062071-7074-1-git-send-email-cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Konrad Rzeszutek Wilk <konrad-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 05/08/2015 12:14 AM, Chris Leech wrote:
> I've had reports of UEFI platforms failing iSCSI boot in various
> configurations, that ended up being caused by network initialization
> scripts getting tripped up by unexpected null addresses (0.0.0.0) being
> reported for gateways, dhcp servers, and dns servers.
> 
> The tianocore EDK2 iSCSI driver generates an iBFT table that always uses
> IPv4-mapped IPv6 addresses for the NIC structure fields.  This results
> in values that are "not present or not specified" being reported as
> ::ffff:0.0.0.0 rather than all zeros as specified.
> 
> The iscsi_ibft module filters unspecified fields from the iBFT from
> sysfs, preventing userspace from using invalid values and making it easy
> to check for the presence of a value.  This currently fails in regard to
> these mapped null addresses.
> 
> In order to remain consistent with how the iBFT information is exposed,
> we should accommodate the behavior of the tianocore iSCSI driver as it's
> already in the wild in a large number of servers.
> 
> Tested under qemu using an OVMF build of tianocore EDK2.
> 
> Signed-off-by: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Looks ok to me.

Reviewed-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>


-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
