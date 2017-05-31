From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 13/17] qla2xxx: Remove redundant code
Date: Wed, 31 May 2017 23:37:47 +0000
Message-ID: <1496273866.2608.27.camel@sandisk.com>
References: <20170530175432.26984-1-himanshu.madhani@cavium.com>
         <20170530175432.26984-14-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:9803 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbdEaXhu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 19:37:50 -0400
In-Reply-To: <20170530175432.26984-14-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <296D7726B2EF94459EAE79A0F9AE7BBA@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2017-05-30 at 10:54 -0700, Himanshu Madhani wrote:
> The reason for hard coding LUN ID to 0 is that, from the FC
> protocol perspective, ABTS does not have any knowledge of
> LUN ID. So, there is no reason for qla2xxx driver to
> manufacture the LUN ID.

Sorry but I think this is completely wrong. Are you aware that
target_submit_tmr() performs an exact match on the LUN specified as the fou=
rth
argument? This patch will cause ABTS requests to be ignored that apply to
commands that have been submitted to another LUN than LUN 0.

Please note that I had proposed a better approach three months ago on the
target-devel mailing list and that I'm still waiting for someone from Caviu=
m to
review these patches:
* [PATCH v6 09/33] target: Make it possible to specify I_T nexus for SCSI
=A0 abort (http://www.spinics.net/lists/target-devel/msg14534.html).
* [PATCH v6 10/33] tcm_qla2xxx: Let the target core look up the LUN of the
=A0 aborted cmd (http://www.spinics.net/lists/target-devel/msg14563.html).

Bart.=
