From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/4] tcm_qla2xxx: T10-Dif set harware capability
Date: Mon, 31 Mar 2014 18:11:11 -0700
Message-ID: <1396314671.22665.76.camel@haakon3.risingtidesystems.com>
References: <1396047927-14189-1-git-send-email-quinn.tran@qlogic.com>
	 <1396047927-14189-3-git-send-email-quinn.tran@qlogic.com>
	 <5336100B.1010604@mellanox.com>
	 <504EB66DAC8D234EB8E8560985C2D7AD46CE91BC@avmb2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <504EB66DAC8D234EB8E8560985C2D7AD46CE91BC@avmb2.qlogic.org>
Sender: target-devel-owner@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>
Cc: sagi grimberg <sagig@mellanox.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

 On Mon, 2014-03-31 at 15:38 +0000, Quinn Tran wrote:
> On 3/28/14 5:12 PM, "sagi grimberg" <sagig@mellanox.com> wrote:
> 
> >On 3/29/2014 2:05 AM, Quinn Tran wrote:
> >> Set Protection Type(1,2,3) capabilities, Guarg type (CRC/IPchksm)
> >> capabilities bits to let TCM core knows of HW/fabric capabilities.
> >>
> >> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> >> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> >> ---
> >>   drivers/scsi/qla2xxx/tcm_qla2xxx.c | 23 +++++++++++++++++++++++
> >>   drivers/scsi/qla2xxx/tcm_qla2xxx.h |  1 +
> >>   2 files changed, 24 insertions(+)
> >>
> >> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> >>b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> >> index b23a0ff..4d93081 100644
> >> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> >> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c

<SNIP>

> >> +
> >> +    if (scsi_host_get_prot(lport->qla_vha->host)) {
> >> +            tpg->se_tpg.fabric_sup_prot_type = (TARGET_DIF_TYPE0_PROT|
> >> +                    TARGET_DIF_TYPE1_PROT|TARGET_DIF_TYPE2_PROT|
> >> +                    TARGET_DIF_TYPE3_PROT);
> >> +
> >> +            tpg->se_tpg.fabric_sup_guard_type = TARGET_GUARD_CRC|
> >> +                    TARGET_GUARD_IP;
> >> +    }
> >>
> >>      ret = core_tpg_register(&tcm_qla2xxx_fabric_configfs->tf_ops, wwn,
> >>                              &tpg->se_tpg, tpg, TRANSPORT_TPG_TYPE_NORMAL);
> >> @@ -1127,6 +1147,8 @@ static ssize_t tcm_qla2xxx_npiv_tpg_store_enable(
> >>              qlt_stop_phase1(vha->vha_tgt.qla_tgt);
> >>      }
> >>
> >> +    core_tpg_set_fabric_t10dif(se_tpg, tpg->tpg_attrib.t10dif_force_on);
> >> +
> >
> >Any way we can get this logic to be shared also with iscsi, srp, etc...
> >all fabrics should
> >be set with t10dif right? so I would imagine it would be better to
> >centralize it right?
> 
> QT> Not sure how you want this logic to be shared.  This patch is specific
> to Qlogic driver registering its capabilities.
> 

I think that Sagi was referring to a target_core_fabric_ops callback to
query protection information from the fabric..

As mentioned in the last response, this would work just fine on
a /sys/kernel/config/target/$FABRIC/$WWPN/$TPGT context basis, if it
wasn't for iscsi-target / iser-target sharing the same endpoint while
still allowing different protection modes.

--nab
