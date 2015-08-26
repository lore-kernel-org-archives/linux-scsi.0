From: Calvin Owens <calvinowens@fb.com>
Subject: Re: [PATCH 0/2] mpt3sas: Reference counting fixes from in-flight
 mpt2sas
Date: Wed, 26 Aug 2015 16:54:34 -0700
Message-ID: <20150826235434.GA8843@mail.thefacebook.com>
References: <1440562184-23945-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43925 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751769AbbHZXzK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2015 19:55:10 -0400
Content-Disposition: inline
In-Reply-To: <1440562184-23945-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, "MPT-FusionLinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>, Nicholas Bellinger <nab@linux-iscsi.org>, kernel-team@fb.com

On Wednesday 08/26 at 04:09 +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Hi James & Co,
> 
> This series is a mpt3sas forward port of Calvin Owens' in-flight
> reference counting bugfixes for mpt2sas LLD code here:
> 
> [PATCH v4 0/2] Fixes for memory corruption in mpt2sas
> http://marc.info/?l=linux-scsi&m=143951695904115&w=2

Nicholas,

I'm glad to hear these fixes were helpful! I was planning on porting to
mpt3sas in the near future, thanks for saving me the trouble :)

Calvin

> The differences between mpt2sas + mpt3sas in this area are very,
> very small, and is required to address a NULL pointer dereference
> OOPsen in _scsih_probe_sas() -> mpt3sas_transport_port_add() ->
> sas_port_add_phy() that I've been hitting occasionally on boot
> during initial LUN scan.
> 
> So far this code has been tested on v3.14.47 with a small cluster
> using SAS3008 HBAs plus a few preceeding upstream mpt3sas patches
> so these patches apply cleanly, and with the changes in place the
> original OOPsen appears to be resolved.
> 
> This patch series is cut atop v4.2-rc1 code, and barring any
> objections from Avago folks et al., should be considered along
> with Calvin's mpt2sas patch set for v4.3-rc1 code.
> 
> Thank you,
> 
> --nab
> 
> Nicholas Bellinger (2):
>   mpt3sas: Refcount sas_device objects and fix unsafe list usage
>   mpt3sas: Refcount fw_events and fix unsafe list usage
> 
>  drivers/scsi/mpt3sas/mpt3sas_base.h      |  23 +-
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 592 ++++++++++++++++++++++---------
>  drivers/scsi/mpt3sas/mpt3sas_transport.c |  12 +-
>  3 files changed, 449 insertions(+), 178 deletions(-)
> 
> -- 
> 1.9.1
> 
