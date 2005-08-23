From: Jim Ramsay <jim.ramsay@gmail.com>
Subject: Re: [PATCH 3/3] Add disk hotswap support to libata RESEND #2
Date: Tue, 23 Aug 2005 13:41:09 -0600
Message-ID: <4789af9e050823124140eb924f@mail.gmail.com>
References: <355e5e5e05080103021a8239df@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.202]:25866 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932335AbVHWTlL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2005 15:41:11 -0400
Received: by zproxy.gmail.com with SMTP id r28so923761nza
        for <linux-scsi@vger.kernel.org>; Tue, 23 Aug 2005 12:41:09 -0700 (PDT)
In-Reply-To: <355e5e5e05080103021a8239df@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-ide <linux-ide@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 8/1/05, Lukasz Kosewski <lkosewsk@gmail.com> wrote:
> Patch 03:  Have sata_promise use the perfect, flawless API from the
> previous patch

Hmmm... Flawless :)

Then I must have found an undocumented feature!  I've applied this set
of patches to a 2.6.11 kernel (with few problems) and ran into a bunch
of "scheduling while atomic" errors when hotplugging a drive, culprit
being probably scsi_sysfs.c where scsi_remove_device locks a mutex, or
perhaps when it then calls class_device_unregister, which does a
'down_write'.

Perhaps we need some sort of workqueue for hotplug requests to get
them out of the atomic interrupt handler context where they originate?

-- 
Jim Ramsay
"Me fail English?  That's unpossible!"
