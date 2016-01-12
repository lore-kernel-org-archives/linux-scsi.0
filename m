From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/1] scsi: add Synology to 1024 sector blacklist
Date: Tue, 12 Jan 2016 18:54:55 +0100
Message-ID: <56953DEF.1050306@redhat.com>
References: <1452206045-18332-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34642 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbcALRzA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2016 12:55:00 -0500
Received: by mail-wm0-f65.google.com with SMTP id b14so32676083wmb.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2016 09:54:59 -0800 (PST)
In-Reply-To: <1452206045-18332-1-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mchristi@redhat.com, linux-scsi@vger.kernel.org



On 07/01/2016 23:34, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> 
> Another iscsi target that cannot handle large IOs,
> but does not tell us a limit.
> 
> The Synology iSCSI targets report:
> 
> Block limits VPD page (SBC):
>   Write same no zero (WSNZ): 0
>   Maximum compare and write length: 0 blocks
>   Optimal transfer length granularity: 0 blocks
>   Maximum transfer length: 0 blocks
>   Optimal transfer length: 0 blocks
>   Maximum prefetch length: 0 blocks
>   Maximum unmap LBA count: 0
>   Maximum unmap block descriptor count: 0
>   Optimal unmap granularity: 0
>   Unmap granularity alignment valid: 0
>   Unmap granularity alignment: 0
>   Maximum write same length: 0x0 blocks
> 
> and the size of the command it can handle seems to depend on how much
> memory it can allocate at the time. This results in IO errors when
> handling large IOs. This patch just has us use the old 1024 default
> sectors for this target by adding it to the scsi blacklist. We do
> not have good contacs with this vendors, so I have not been able to
> try and fix on their side.

Synology is just (an old fork of?) LIO.  IIRC I saw similar problems a
couple years ago with LIO because iscsit_map_iovec maps everything a
page at a time and produced too large an iovec for the underlying
storage.  I'm afraid you're going to get this for pretty much every user
of LIO.

Paolo
