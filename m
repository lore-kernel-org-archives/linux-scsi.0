From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/4] tcm_qla2xxx: T10-Dif set harware capability
Date: Tue, 01 Apr 2014 10:40:13 -0700
Message-ID: <1396374013.18589.9.camel@haakon3.risingtidesystems.com>
References: <1396047927-14189-1-git-send-email-quinn.tran@qlogic.com>
	 <1396047927-14189-3-git-send-email-quinn.tran@qlogic.com>
	 <5336100B.1010604@mellanox.com>
	 <504EB66DAC8D234EB8E8560985C2D7AD46CE91BC@avmb2.qlogic.org>
	 <1396314671.22665.76.camel@haakon3.risingtidesystems.com>
	 <533A731E.4000709@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:57835 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaDARkW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2014 13:40:22 -0400
In-Reply-To: <533A731E.4000709@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Quinn Tran <quinn.tran@qlogic.com>, sagi grimberg <sagig@mellanox.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

On Tue, 2014-04-01 at 11:04 +0300, Sagi Grimberg wrote:
> On 4/1/2014 4:11 AM, Nicholas A. Bellinger wrote:
> <SNIP>
> >>>> +
> >>>> +    if (scsi_host_get_prot(lport->qla_vha->host)) {
> >>>> +            tpg->se_tpg.fabric_sup_prot_type = (TARGET_DIF_TYPE0_PROT|
> >>>> +                    TARGET_DIF_TYPE1_PROT|TARGET_DIF_TYPE2_PROT|
> >>>> +                    TARGET_DIF_TYPE3_PROT);
> >>>> +
> >>>> +            tpg->se_tpg.fabric_sup_guard_type = TARGET_GUARD_CRC|
> >>>> +                    TARGET_GUARD_IP;
> >>>> +    }
> >>>>
> >>>>       ret = core_tpg_register(&tcm_qla2xxx_fabric_configfs->tf_ops, wwn,
> >>>>                               &tpg->se_tpg, tpg, TRANSPORT_TPG_TYPE_NORMAL);
> >>>> @@ -1127,6 +1147,8 @@ static ssize_t tcm_qla2xxx_npiv_tpg_store_enable(
> >>>>               qlt_stop_phase1(vha->vha_tgt.qla_tgt);
> >>>>       }
> >>>>
> >>>> +    core_tpg_set_fabric_t10dif(se_tpg, tpg->tpg_attrib.t10dif_force_on);
> >>>> +
> >>> Any way we can get this logic to be shared also with iscsi, srp, etc...
> >>> all fabrics should
> >>> be set with t10dif right? so I would imagine it would be better to
> >>> centralize it right?
> >> QT> Not sure how you want this logic to be shared.  This patch is specific
> >> to Qlogic driver registering its capabilities.
> >>
> > I think that Sagi was referring to a target_core_fabric_ops callback to
> > query protection information from the fabric..
> >
> > As mentioned in the last response, this would work just fine on
> > a /sys/kernel/config/target/$FABRIC/$WWPN/$TPGT context basis, if it
> > wasn't for iscsi-target / iser-target sharing the same endpoint while
> > still allowing different protection modes.
> 
> So no way to get it centralized?

Yes, still working on how that might look..

>  I still don't understand the iscsi/iser constraint.

Every other fabric aside from iscsi/iser could simply provide a
TFO->get_fabric_prot(se_tpg) to query for supported PI.

The reason why iscsi/iser is unique is because we can have different
network portals (eg: iser protected + traditional iscsi unprotected) on
the same se_tpg endpoint.

--nab

