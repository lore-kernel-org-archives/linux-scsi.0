From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v3 3/4] sd: Make synchronize cache upon shutdown
 asynchronous
Date: Thu, 20 Apr 2017 22:52:22 +0000
Message-ID: <1492728740.2642.14.camel@sandisk.com>
References: <20170417173436.15555-1-bart.vanassche@sandisk.com>
         <20170417173436.15555-4-bart.vanassche@sandisk.com>
         <20170418144429.GA28949@bblock-ThinkPad-W530>
         <1492530984.3306.25.camel@HansenPartnership.com>
         <1492559235.2689.27.camel@sandisk.com>
         <1492559772.3306.58.camel@HansenPartnership.com>
         <1492725550.2642.9.camel@sandisk.com>
         <1492726397.21601.16.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:13212 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S947851AbdDTWw0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 18:52:26 -0400
In-Reply-To: <1492726397.21601.16.camel@HansenPartnership.com>
Content-Language: en-US
Content-ID: <A121C3D9C0B7F34CA30034C8F4DF87CC@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "bblock@linux.vnet.ibm.com" <bblock@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "maxg@mellanox.com" <maxg@mellanox.com>, "israelr@mellanox.com" <israelr@mellanox.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Thu, 2017-04-20 at 15:13 -0700, James Bottomley wrote:
> How is that possible?  Once the device goes into the CANCEL state, it
> no longer can be found by starget_for_each_device() because
> scsi_device_get() returns NULL ...

scsi_target_block() is not serialized against __scsi_remove_device(). I thi=
nk
the following sequence of events can cause a queue to be stopped for a devi=
ce
in the CANCEL state:
(a) scsi_target_block() triggers a call to scsi_get_device().
(b) __scsi_remove_device() is called from the context of another thread.
(c) __scsi_remove_device() changes the device state into SDEV_CANCEL.
(d) scsi_internal_device_block() calls blk_mq_stop_hw_queue().

Bart.=
