From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/1] scsi: add Synology to 1024 sector blacklist
Date: Wed, 13 Jan 2016 01:33:44 -0800
Message-ID: <1452677624.27508.70.camel@haakon3.risingtidesystems.com>
References: <1452206045-18332-1-git-send-email-mchristi@redhat.com>
	 <56953DEF.1050306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35736 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbcAMJdp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2016 04:33:45 -0500
In-Reply-To: <56953DEF.1050306@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: mchristi@redhat.com, linux-scsi@vger.kernel.org

Hi Paolo & MNC,

On Tue, 2016-01-12 at 18:54 +0100, Paolo Bonzini wrote:
> 
> On 07/01/2016 23:34, mchristi@redhat.com wrote:
> > From: Mike Christie <mchristi@redhat.com>
> > 
> > Another iscsi target that cannot handle large IOs,
> > but does not tell us a limit.
> > 
> > The Synology iSCSI targets report:
> > 
> > Block limits VPD page (SBC):
> >   Write same no zero (WSNZ): 0
> >   Maximum compare and write length: 0 blocks
> >   Optimal transfer length granularity: 0 blocks
> >   Maximum transfer length: 0 blocks
> >   Optimal transfer length: 0 blocks
> >   Maximum prefetch length: 0 blocks
> >   Maximum unmap LBA count: 0
> >   Maximum unmap block descriptor count: 0
> >   Optimal unmap granularity: 0
> >   Unmap granularity alignment valid: 0
> >   Unmap granularity alignment: 0
> >   Maximum write same length: 0x0 blocks
> > 
> > and the size of the command it can handle seems to depend on how much
> > memory it can allocate at the time. This results in IO errors when
> > handling large IOs. This patch just has us use the old 1024 default
> > sectors for this target by adding it to the scsi blacklist. We do
> > not have good contacs with this vendors, so I have not been able to
> > try and fix on their side.
> 
> Synology is just (an old fork of?) LIO.

Last time I dissembled their build a few year back, Synology was still
using a 2010 vintage pre-mainline version of LIO 3.x along with a
substantial mess of extra junk.

> IIRC I saw similar problems a
> couple years ago with LIO because iscsit_map_iovec maps everything a
> page at a time and produced too large an iovec for the underlying
> storage.  I'm afraid you're going to get this for pretty much every user
> of LIO.
> 

Two points here.

We've been exposing backend dev->dev_attrib.hw_max_sectors settings for
block limits EVPD for FILEIO based on iov limits, and IBLOCK based on
queue_max_hw_sectors() for some time now.

So initiators that honor block limits EVPD will work as expected.

However, it was only last year when commit 8f9b5654 was added for
generating OVERFLOW based on backend driver limit, in order to play nice
with older initiators that do not honor block limits EVPD.

