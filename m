From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v5 0/4] Avoid that __scsi_remove_device() hangs
Date: Wed, 26 Apr 2017 18:50:59 +0000
Message-ID: <1493232656.2632.7.camel@sandisk.com>
References: <20170425205354.21181-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:53607 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965496AbdDZSvC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Apr 2017 14:51:02 -0400
In-Reply-To: <20170425205354.21181-1-bart.vanassche@sandisk.com>
Content-Language: en-US
Content-ID: <1BEE889673E8B34F935976957ACFD6D8@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2017-04-25 at 13:53 -0700, Bart Van Assche wrote:
> __scsi_remove_device() hangs if it is waiting for the SYNCHRONIZE CACHE
> command submitted by the sd driver to finish if the block layer queue is
> stopped and does not get restarted. This patch series avoids that that
> hang occurs.
> [ ... ]

Hello Martin and James,

Even with this version of this patch series there is still a lockup possibl=
e,
namely if the sd events checker submits a TUR while a SCSI device is blocke=
d
and before __scsi_remove_device() calls device_del(). The latter function
namely waits for sd_check_events() to finish.

Bart.=
