From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v3 1/6] [SCSI] Add a kernel config option for enhanced
 Unit Attention support
Date: Wed, 19 Jun 2013 18:35:12 +0000
Message-ID: <1371666911.2409.72.camel@dabdike>
References: <1371663761-22481-1-git-send-email-emilne@redhat.com>
	 <1371663761-22481-2-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:53663 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377Ab3FSSfO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jun 2013 14:35:14 -0400
In-Reply-To: <1371663761-22481-2-git-send-email-emilne@redhat.com>
Content-Language: en-US
Content-ID: <1683DA38A067FB4FAB4F027FB729A4DA@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "rwheeler@redhat.com" <rwheeler@redhat.com>

On Wed, 2013-06-19 at 13:42 -0400, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
> 
> Added CONFIG_SCSI_ENHANCED_UA kernel config option to enable changes
> in the SCSI mid-layer which detect and report certain Unit Attention
> conditions reported by devices.  These changes are primarily useful
> when storage arrays that can be reconfigured are being used, so the
> config option would normally not be used unless it was needed.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>  drivers/scsi/Kconfig | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index e955978..5d1e614 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -280,6 +280,18 @@ config SCSI_WAIT_SCAN
>  # disabling it, whereas people who accidentally switch it off may wonder why
>  # their mkinitrd gets into trouble.
>  
> +config SCSI_ENHANCED_UA
> +       bool "Enhanced SCSI Unit Attention handling"
> +       depends on SCSI
> +       help
> +	 Certain SCSI devices report changes via a UNIT ATTENTION code.
> +	 (For example, the addition or removal of LUNs from a target, or
> +	 changing the number of logical blocks on a LUN.)  This option
> +	 enables reporting of these changes via udev events, so that the
> +	 device can be rescanned to find out what has changed.  This is
> +	 primarily useful when storage arrays that can be reconfigured
> +	 are attached to the system, otherwise you can say N here.
> +

I don't think we need this.  If we're going to do device events, we
should do it unconditionally.  The recourse for not wanting them is not
listening for them.  That way we don't have two separate config branches
to maintain, one of which will surely bitrot.

James

