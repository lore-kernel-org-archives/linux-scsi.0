From: "Rolf Eike Beer" <eike-kernel@sf-tec.de>
Subject: RE: [PATCH]: be2iscsi: Fix MSIX interrupt names
Date: Wed, 1 Jun 2011 21:41:02 +0200
Message-ID: <67dd21012f4b055efd0ef484712ddb30.squirrel@webmail.sf-mail.de>
References: <4DD6AEB7.2090900@redhat.com> <4DD6AF29.8090903@redhat.com>
    <50725EF61B96174EB1803401F1A2E37335099FC989@EXMAIL.ad.emulex.com>,<4DD6B83B.5000703@redhat.com>
    <50725EF61B96174EB1803401F1A2E3733508E57DFE@EXMAIL.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:58745 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771Ab1FATlG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jun 2011 15:41:06 -0400
In-Reply-To: <50725EF61B96174EB1803401F1A2E3733508E57DFE@EXMAIL.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan.Kallickal@Emulex.Com
Cc: prarit@redhat.com, linux-scsi@vger.kernel.org, mchristi@redhat.com

> I have taken the original patch from Prarit and made changes to move the
> allocation
> inside the main for loop along with request_irq.
>
> I feel doing devres would be good but going to take some time. However, we
> need to fix this now and hence
> am submitting this patch. When we have a final devres solution working and
> tested ,we would move over.

I think this is a good way to go.

+			if (!phba->msi_name[i]) {
+				ret = -ENOMEM;
+				if (!i)
+					return ret;
+				goto free_msix_irqs;
+			}

That "if (!i)" stuff is useless. If you enter the loop with i==0 j will
become -1 which causes the loop never to execute. The same is true for the
request_irq() error handling below.

Eike
