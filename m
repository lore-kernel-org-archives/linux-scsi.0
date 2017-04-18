From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v3 3/4] sd: Make synchronize cache upon shutdown
 asynchronous
Date: Tue, 18 Apr 2017 16:06:21 +0000
Message-ID: <1492531579.2689.5.camel@sandisk.com>
References: <20170417173436.15555-1-bart.vanassche@sandisk.com>
         <20170417173436.15555-4-bart.vanassche@sandisk.com>
         <20170418144429.GA28949@bblock-ThinkPad-W530>
         <1492530984.3306.25.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:13454 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751849AbdDRQG1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2017 12:06:27 -0400
In-Reply-To: <1492530984.3306.25.camel@HansenPartnership.com>
Content-Language: en-US
Content-ID: <C5B2A309851C8643854F8DE4D098562C@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "bblock@linux.vnet.ibm.com" <bblock@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "maxg@mellanox.com" <maxg@mellanox.com>, "israelr@mellanox.com" <israelr@mellanox.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Tue, 2017-04-18 at 08:56 -0700, James Bottomley wrote:
> How about this approach.  It goes straight to DEL if the device is
> blocked (skipping CANCEL).  This means that all the commands issued in=20
> ->shutdown will error in the mid-layer, thus making the removal proceed
> without being stopped.

Hello James,

I think that's a good start but not a full solution. The block layer queue
still needs to be restarted to make sure that any requests that got queued
after the transition to the SDEV_BLOCK state and before the transition to
SDEV_DEL get processed. Anyway, I will see whether I can come up with a
patch based on this approach.

Bart.
