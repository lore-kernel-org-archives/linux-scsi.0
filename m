From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [ufs]: [scsi]: BUG: spinlock recursion on CPU#4
Date: Mon, 5 Jun 2017 15:23:00 +0000
Message-ID: <1496676179.2623.3.camel@sandisk.com>
References: <bd79226b-833c-f53b-f92a-0c4ebffeb1ee@codeaurora.org>
         <1496325738.3075.1.camel@sandisk.com>
         <94899e9e-abd3-5e70-838a-5a4659a9483e@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:50602 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751162AbdFEPXJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2017 11:23:09 -0400
In-Reply-To: <94899e9e-abd3-5e70-838a-5a4659a9483e@codeaurora.org>
Content-Language: en-US
Content-ID: <29FC2DE7CD9B6E448879E4E36CD2A4EA@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
Cc: "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>

On Mon, 2017-06-05 at 12:16 +0530, Asutosh Das (asd) wrote:
> It's on 4.4 and its an Android kernel.
>=20
> No - I haven't tried it out yet. I could get some clues from the=20
> call-stack itself, like I explained before. I can try these configs=20
> though. While I do that, I'd like to know your thoughts on my analysis.=20
> Do you think with the current data, it makes sense?

Hello Asutosh,

If your analysis is correct then I think the easiest solution will be to sw=
itch
to scsi-mq. The scsi-mq .queue_rq function is called without the host lock =
held
and hence there is no need to unlock the host lock from inside the queue_rq
function.

Bart.=
