From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Configure NPIV fc_vport via
 tcm_qla2xxx_npiv_make_lport
Date: Wed, 15 Jan 2014 16:06:55 +0000
Message-ID: <987039D6-194C-4CB2-910E-4FEEBB9630B9@qlogic.com>
References: <1389764525-24453-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_987039D6194C4CB2910E4FEEBB9630B9qlogiccom_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:33744 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159AbaAOQG7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jan 2014 11:06:59 -0500
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id s0FFmXH3014914
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jan 2014 08:06:57 -0800
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1h8euxm00t-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jan 2014 08:06:56 -0800
In-Reply-To: <1389764525-24453-1-git-send-email-nab@daterainc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Sawan Chandak <sawan.chandak@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

--_000_987039D6194C4CB2910E4FEEBB9630B9qlogiccom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable



Sent from my iPhone. Please excuse any typos.

> On Jan 14, 2014, at 10:02 PM, "Nicholas A. Bellinger" <nab@daterainc.com>=
 wrote:
>=20
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>=20
> Hi Saurav & Co,
>=20
> Here is the updated NPIV patch on top of the original here:
>=20
>  [PATCH] qla2xxx: Enhancements to enable NPIV support for QLOGIC ISPs wit=
h TCM/LIO.
>  http://marc.info/?l=3Dlinux-scsi&m=3D138930044930212&w=3D2
>=20
Thanks. We will review and get back.


> As previously dicussed, it moves fc_vport creation into tcm_qla2xxx
> control plane code thus allowing everything required for NPIV port
> creation to be encapsulated within configfs.
>=20
> There are still some bugs to be resolved.  Namely:
>=20
> * Determine how to save 'point-to-point' NVRAM settings across target res=
tart

We will look into this.=20

> * Figure out why the initiator logs in, but doesn't perform LUN scan on
>   the first login attempt
> * Determine if it's possible to collapse the name formatting further,
>   by generating $NPIV_WWNN internally
> * Determine proper NPIV format for EVPD=3D0x83 SCSI name string
>=20
> Aside from these remaining issues, multiple NPIV ports can be configured
> on a single physical FC port, and initial I/O appears to be functioning
> as expected.
>=20

That's good.
> Please review.
>=20
> Thank you,
>=20
> --nab
>=20
> --------------------------------------------------------------------
>=20
> This patch changes qla2xxx qlt_lport_register() code to accept
> target_lport_ptr + npiv_wwpn + npiv_wwnn parameters, and updates
> tcm_qla2xxx to use the new tcm_qla2xxx_lport_register_npiv_cb()
> callback for invoking fc_vport_create() from configfs context
> via tcm_qla2xxx_npiv_make_lport() code.
>=20
> In order for this to work, the qlt_lport_register() callback is
> now called without holding qla_tgt_mutex, as the fc_vport creation
> process will call qlt_vport_create() -> qlt_add_target(), which
> already expects to acquire it.
>=20
> It enforces /sys/kernel/config/target/qla2xxx_npiv/$NPIV_WWPN
> naming in the following format:
>=20
>     $PHYSICAL_WWPN@$NPIV_WWPN:$NPIV_WWNN
>=20
> and assumes the $PHYSICAL_WWPN in question has already had been
> configured for target mode in non NPIV mode.
>=20
> Finally, it updates existing tcm_qla2xxx_lport_register_cb() logic
> to setup the non NPIV assignments that have now been moved out of
> qlt_lport_register() code.
>=20
> Cc: Sawan Chandak <sawan.chandak@qlogic.com>
> Cc: Quinn Tran <quinn.tran@qlogic.com>
> Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
> drivers/scsi/qla2xxx/qla_target.c  |   25 ++++-----
> drivers/scsi/qla2xxx/qla_target.h  |    4 +-
> drivers/scsi/qla2xxx/tcm_qla2xxx.c |  106 ++++++++++++++++++++++++++-----=
-----
> 3 files changed, 88 insertions(+), 47 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> index 34ed246..b596f8b 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -4235,8 +4235,9 @@ static void qlt_lport_dump(struct scsi_qla_host *vh=
a, u64 wwpn,
>  * @callback:  lport initialization callback for tcm_qla2xxx code
>  * @target_lport_ptr: pointer for tcm_qla2xxx specific lport data
>  */
> -int qlt_lport_register(struct qla_tgt_func_tmpl *qla_tgt_ops, u64 wwpn,
> -    int (*callback)(struct scsi_qla_host *), void *target_lport_ptr)
> +int qlt_lport_register(void *target_lport_ptr, u64 phys_wwpn,
> +               u64 npiv_wwpn, u64 npiv_wwnn,
> +               int (*callback)(struct scsi_qla_host *, void *, u64, u64)=
)
> {
>    struct qla_tgt *tgt;
>    struct scsi_qla_host *vha;
> @@ -4259,7 +4260,7 @@ int qlt_lport_register(struct qla_tgt_func_tmpl *ql=
a_tgt_ops, u64 wwpn,
>            continue;
>=20
>        spin_lock_irqsave(&ha->hardware_lock, flags);
> -        if (host->active_mode & MODE_TARGET) {
> +        if ((!npiv_wwpn || !npiv_wwnn) && host->active_mode & MODE_TARGE=
T) {
>            pr_debug("MODE_TARGET already active on qla2xxx(%d)\n",
>                host->host_no);
>            spin_unlock_irqrestore(&ha->hardware_lock, flags);
> @@ -4273,24 +4274,18 @@ int qlt_lport_register(struct qla_tgt_func_tmpl *=
qla_tgt_ops, u64 wwpn,
>                " qla2xxx scsi_host\n");
>            continue;
>        }
> -        qlt_lport_dump(vha, wwpn, b);
> +        qlt_lport_dump(vha, phys_wwpn, b);
>=20
>        if (memcmp(vha->port_name, b, WWN_SIZE)) {
>            scsi_host_put(host);
>            continue;
>        }
> -        /*
> -         * Setup passed parameters ahead of invoking callback
> -         */
> -        ha->tgt.tgt_ops =3D qla_tgt_ops;
> -        vha->vha_tgt.target_lport_ptr =3D target_lport_ptr;
> -        rc =3D (*callback)(vha);
> -        if (rc !=3D 0) {
> -            ha->tgt.tgt_ops =3D NULL;
> -            vha->vha_tgt.target_lport_ptr =3D NULL;
> -            scsi_host_put(host);
> -        }
>        mutex_unlock(&qla_tgt_mutex);
> +
> +        rc =3D (*callback)(vha, target_lport_ptr, npiv_wwpn, npiv_wwnn);
> +        if (rc !=3D 0)
> +            scsi_host_put(host);
> +
>        return rc;
>    }
>    mutex_unlock(&qla_tgt_mutex);
> diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla=
_target.h
> index b33e411..1d10eec 100644
> --- a/drivers/scsi/qla2xxx/qla_target.h
> +++ b/drivers/scsi/qla2xxx/qla_target.h
> @@ -932,8 +932,8 @@ void qlt_disable_vha(struct scsi_qla_host *);
>  */
> extern int qlt_add_target(struct qla_hw_data *, struct scsi_qla_host *);
> extern int qlt_remove_target(struct qla_hw_data *, struct scsi_qla_host *=
);
> -extern int qlt_lport_register(struct qla_tgt_func_tmpl *, u64,
> -            int (*callback)(struct scsi_qla_host *), void *);
> +extern int qlt_lport_register(void *, u64, u64, u64,
> +            int (*callback)(struct scsi_qla_host *, void *, u64, u64));
> extern void qlt_lport_deregister(struct scsi_qla_host *);
> extern void qlt_unreg_sess(struct qla_tgt_sess *);
> extern void qlt_fc_port_added(struct scsi_qla_host *, fc_port_t *);
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tc=
m_qla2xxx.c
> index 113ca95..75a141b 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -1559,14 +1559,18 @@ static int tcm_qla2xxx_init_lport(struct tcm_qla2=
xxx_lport *lport)
>    return 0;
> }
>=20
> -static int tcm_qla2xxx_lport_register_cb(struct scsi_qla_host *vha)
> +static int tcm_qla2xxx_lport_register_cb(struct scsi_qla_host *vha,
> +                     void *target_lport_ptr,
> +                     u64 npiv_wwpn, u64 npiv_wwnn)
> {
> -    struct tcm_qla2xxx_lport *lport;
> +    struct qla_hw_data *ha =3D vha->hw;
> +    struct tcm_qla2xxx_lport *lport =3D
> +            (struct tcm_qla2xxx_lport *)target_lport_ptr;
>    /*
> -     * Setup local pointer to vha, NPIV VP pointer (if present) and
> -     * vha->tcm_lport pointer
> +     * Setup tgt_ops, local pointer to vha and target_lport_ptr
>     */
> -    lport =3D (struct tcm_qla2xxx_lport *)vha->vha_tgt.target_lport_ptr;
> +    ha->tgt.tgt_ops =3D &tcm_qla2xxx_template;
> +    vha->vha_tgt.target_lport_ptr =3D target_lport_ptr;
>    lport->qla_vha =3D vha;
>=20
>    return 0;
> @@ -1598,8 +1602,8 @@ static struct se_wwn *tcm_qla2xxx_make_lport(
>    if (ret !=3D 0)
>        goto out;
>=20
> -    ret =3D qlt_lport_register(&tcm_qla2xxx_template, wwpn,
> -                tcm_qla2xxx_lport_register_cb, lport);
> +    ret =3D qlt_lport_register(lport, wwpn, 0, 0,
> +                 tcm_qla2xxx_lport_register_cb);
>    if (ret !=3D 0)
>        goto out_lport;
>=20
> @@ -1637,20 +1641,70 @@ static void tcm_qla2xxx_drop_lport(struct se_wwn =
*wwn)
>    kfree(lport);
> }
>=20
> +static int tcm_qla2xxx_lport_register_npiv_cb(struct scsi_qla_host *base=
_vha,
> +                          void *target_lport_ptr,
> +                          u64 npiv_wwpn, u64 npiv_wwnn)
> +{
> +    struct fc_vport *vport;
> +    struct Scsi_Host *sh =3D base_vha->host;
> +    struct scsi_qla_host *npiv_vha;
> +    struct tcm_qla2xxx_lport *lport =3D
> +            (struct tcm_qla2xxx_lport *)target_lport_ptr;
> +    struct fc_vport_identifiers vport_id;
> +
> +    if (!qla_tgt_mode_enabled(base_vha)) {
> +        pr_err("qla2xxx base_vha not enabled for target mode\n");
> +        return -EPERM;
> +    }
> +
> +    memset(&vport_id, 0, sizeof(vport_id));
> +    vport_id.port_name =3D npiv_wwpn;
> +    vport_id.node_name =3D npiv_wwnn;
> +    vport_id.roles =3D FC_PORT_ROLE_FCP_INITIATOR;
> +    vport_id.vport_type =3D FC_PORTTYPE_NPIV;
> +    vport_id.disable =3D false;
> +
> +    vport =3D fc_vport_create(sh, 0, &vport_id);
> +    if (!vport) {
> +        pr_err("fc_vport_create failed for qla2xxx_npiv\n");
> +        return -ENODEV;
> +    }
> +    /*
> +     * Setup local pointer to NPIV vhba + target_lport_ptr
> +     */
> +    npiv_vha =3D (struct scsi_qla_host *)vport->dd_data;
> +    npiv_vha->vha_tgt.target_lport_ptr =3D target_lport_ptr;
> +    lport->qla_vha =3D npiv_vha;
> +
> +    scsi_host_get(npiv_vha->host);
> +    return 0;
> +}
> +
> +
> static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
>    struct target_fabric_configfs *tf,
>    struct config_group *group,
>    const char *name)
> {
>    struct tcm_qla2xxx_lport *lport;
> -    u64 npiv_wwpn, npiv_wwnn;
> +    u64 phys_wwpn, npiv_wwpn, npiv_wwnn;
> +    char *p, tmp[128];
>    int ret;
> -    struct scsi_qla_host *vha =3D NULL;
> -    struct qla_hw_data *ha =3D NULL;
> -    scsi_qla_host_t *base_vha =3D NULL;
>=20
> -    if (tcm_qla2xxx_npiv_parse_wwn(name, strlen(name)+1,
> -                &npiv_wwpn, &npiv_wwnn) < 0)
> +    snprintf(tmp, 128, "%s", name);
> +
> +    p =3D strchr(tmp, '@');
> +    if (!p) {
> +        pr_err("Unable to locate NPIV '@' seperator\n");
> +        return ERR_PTR(-EINVAL);
> +    }
> +    *p++ =3D '\0';
> +
> +    if (tcm_qla2xxx_parse_wwn(tmp, &phys_wwpn, 1) < 0)
> +        return ERR_PTR(-EINVAL);
> +
> +    if (tcm_qla2xxx_npiv_parse_wwn(p, strlen(p)+1,
> +                       &npiv_wwpn, &npiv_wwnn) < 0)
>        return ERR_PTR(-EINVAL);
>=20
>    lport =3D kzalloc(sizeof(struct tcm_qla2xxx_lport), GFP_KERNEL);
> @@ -1668,21 +1722,11 @@ static struct se_wwn *tcm_qla2xxx_npiv_make_lport=
(
>    if (ret !=3D 0)
>        goto out;
>=20
> -    ret =3D qlt_lport_register(&tcm_qla2xxx_template, npiv_wwpn,
> -                tcm_qla2xxx_lport_register_cb, lport);
> -
> +    ret =3D qlt_lport_register(lport, phys_wwpn, npiv_wwpn, npiv_wwnn,
> +                 tcm_qla2xxx_lport_register_npiv_cb);
>    if (ret !=3D 0)
>        goto out_lport;
>=20
> -    vha =3D lport->qla_vha;
> -    ha =3D vha->hw;
> -    base_vha =3D pci_get_drvdata(ha->pdev);
> -
> -    if (!qla_tgt_mode_enabled(base_vha)) {
> -        ret =3D -EPERM;
> -        goto out_lport;
> -    }
> -
>    return &lport->lport_wwn;
> out_lport:
>    vfree(lport->lport_loopid_map);
> @@ -1696,14 +1740,16 @@ static void tcm_qla2xxx_npiv_drop_lport(struct se=
_wwn *wwn)
> {
>    struct tcm_qla2xxx_lport *lport =3D container_of(wwn,
>            struct tcm_qla2xxx_lport, lport_wwn);
> -    struct scsi_qla_host *vha =3D lport->qla_vha;
> -    struct Scsi_Host *sh =3D vha->host;
> +    struct scsi_qla_host *npiv_vha =3D lport->qla_vha;
> +    struct qla_hw_data *ha =3D npiv_vha->hw;
> +    scsi_qla_host_t *base_vha =3D pci_get_drvdata(ha->pdev);
> +
> +    scsi_host_put(npiv_vha->host);
>    /*
>     * Notify libfc that we want to release the vha->fc_vport
>     */
> -    fc_vport_terminate(vha->fc_vport);
> -
> -    scsi_host_put(sh);
> +    fc_vport_terminate(npiv_vha->fc_vport);
> +    scsi_host_put(base_vha->host);
>    kfree(lport);
> }
>=20
> --=20
> 1.7.10.4
>=20

--_000_987039D6194C4CB2910E4FEEBB9630B9qlogiccom_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

eJ8+ImY1AQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEJgAEAIQAAADEyREQ5NzZG
QzAzMTM4NDFCQTIzMkYwREY3MzA4REZGADoHAQ2ABAACAAAAAgACAAEFgAMADgAAAN4HAQAPABAA
BgA3AAMARQEBIIADAA4AAADeBwEADwAQAAYANwADAEUBAQiABwAYAAAASVBNLk1pY3Jvc29mdCBN
YWlsLk5vdGUAMQgBBIABAE0AAABSZTogW1BBVENIXSBxbGEyeHh4OiBDb25maWd1cmUgTlBJViBm
Y192cG9ydCB2aWEgdGNtX3FsYTJ4eHhfbnBpdl9tYWtlX2xwb3J0ALEbAQOQBgDkHAAAMwAAAAIB
fwABAAAAMgAAADw5ODcwMzlENi0xOTRDLTRDQjItOTEwRS00RkVFQkI5NjMwQjlAcWxvZ2ljLmNv
bT4AAAALAB8OAQAAAAIBCRABAAAAAhMAAP4SAAAWNgAATFpGdWWXWBNhAApmYmlkBAAAY2PAcGcx
MjUyAP4DQ/B0ZXh0AfcCpAPjAgAEY2gKwHNldDAg7wdtAoMAUBFNMgqABrQCgJZ9CoAIyDsJYjE5
DsC/CcMWcgoyFnECgBViKgmwcwnwBJBhdAWyDlADYHOibwGAIEV4EcFuGDBdBlJ2BJAXtgIQcgDA
dH0IUG4aMRAgBcAFoBtkZJogA1IgECIXslx2CJDkd2sLgGQ1HVME8AdADRdwMApxF/Jia21rBnMB
kAAgIEJNX0LgRUdJTn0K/AHxC/L6bAuAZQqBIaQGYAIwHHRAbXkgaVBoAiBlqC4gUB5wYRIAIBAw
HGN1JAEAcCMgdHlwRRkQLiGcPiBPA6BK4QORMTQsIAHQJrIYgKEmoDA6MDIjsE0m0LwiTg5QI2AL
YAQgQSOgGEJlbCGhGDByIiDkPG4BoEBkGIAYYQuA1GMuBaBtJiB3A2AQINY6Jbclt0YDYToHsChG
Ryj3KZQhoXV4LQQAYyUAkC4FsGc+K08gSAZpBgEIcGF2ICYg/QhQLC9PMFAEkBngBAAcwDJoGeB1
cCnyHGBOUKhJViAKsHQRwCACIGkcwG9wNFBmMuMFsGn2ZwuAB0AgMwAJcCs/JiAAIFtQQVRDSF1k
IHELYDJ4OBAsoEVybhmhY2UHgAIwMtFv7yQgKbEecDOkczMwJQAfkSEa4SBRTE8gEEMgeElTUAQg
A/Ay8BJAQ2BNL0xJTyU2NyFooQJAcDovLwDAcipwwwuAAhAvP2w9LkQusgAmbT0xMzg5MykeoDQ0
P1EyDpAmd3Y9DsA2PVQZoR9QI6BX9xngA/ApECAJcB1iJJEcYGsYMAVAYgDQayU9JbdBzQQgcEJS
CGBzbCMgDeC7JFESAGQm0DuwIwBvGjBzBCARsF92OlMFACPgdJ9FcAOgC4A5MTQgbV831fsltxvh
dANgAyALURhQG9HfAQAy4SRgJJApEG8D8BnAOyQgGjF5MvBLkglwcXX+aQlxOpMztAkRSThHtjkx
5mIkESpgYXA6IAtgHEL3O6ILgBvSZjVgA9A8aCW3/0FQMoIKwBngH2BCEhkgB4B5QzB1ZzkTTzEJ
cBkgbO0aMGQjoAewYQeARbA2H7EmICogRBIQBJBtIbG3NcBLcDkiczDQGeAnJQBVSDEtGJAtWCMn
B7BW+FJBTToQEhBH4BnASyH/GPIy0QrAQwJUUR9yIZxB1vkJAG9rSCVMMEGhJU5WkC5GNWAIcDUh
dQVAd2j/JMEzAQuAO7AHMBiSCQBTwU8LgCbQU6AFQGRvB5BuGicFQHAEkBriIExV/k46EB5QA6AC
IDa4MuNQ0L8R8AVAYLFQcRiAECBtBTBvVg9XEgaQRnEnRRFaQWn/OZI5MQjhC2BPoErSGeApsL9T
cRrkWbIccAhwMvFyMUhdNzBiIyAYNUuSJDOyX3hXV05ioEgxBJFLQXn/ZV9XEkUwNKAbsTOzGuQ6
kwBFVlBEPTB4OOIzBgBDU0lopB9gBRD/GcBVf0TxDdBkARyTMwAkAb8JcADAYBFLoQQBClBzJtD+
bU/AR+ALUDm1OlIEIGLSv08xUKRfEQswJcY0YWE6ELspMTmhcF+gDkE1oUY7MB86UicxQtFgFAMg
SS9P/ySQOkAj4BHwTvVpsCpgR+L/cUookRAwYgB7kFSxcX5A6P1m4mdc0H1JI8VCVH1fUjI5QXEg
eQhgMU8mIC0t/ymxgs+D0YVvhn+Hj4iNhD9/UkEywTQEGZQEIDfVN8F09F9sOlJfCXA1cB9gBJD8
KClKlTlAANA4sGU5WoQXjJUFMAXAK2igcGl2sF93d3ADoJA3bgOg/wqxVREboXSRQsIzNA4Ajqd/
SJg5IiRiaHMH0UiJjJ1f+ZBTY2KNgEk4S0FDQjqTfQuAdlzgaXNHJZdQR7Jl/42BHINQpkmzEDEl
tx1gd9DnlWqQUwDAa2WMlI2FgP/9JiBJYvELIBuxOqJdYjki+ncFsGsm0DLyjG+Nc5hG+w3xJcZu
V2GYMlAFX1IoYccN4EuhN9FfdGeiMHTA/xAhJzEy1EcfJbduYTiwBBFvQgOYMqIDmc0tJiCiEmH8
ZGSmgFqTjYAm0F+QKEH1fBhsR7FkIyB81DkTAND/TKNGcZ7/oAEFQAnwGuGpgeggL3N4gC+eAASg
KQCqL1CkL1qEL50aL2vG/FBOpBhVEHQDNHFj8mfxH0t0GuRVb2OiNzAkUEiiWXCQQ0FMtFNAtAj+
OmvIty9CsyPwOiAHgjLy/7iMtZJMoFsBR/IR0EsirfT/EdAcYE8wCfBJOnaloKRalP8EYrWSpKAD
oDOzBGKvryxB/zWCRbBGY5K1JCGNMUuSlW//lniXYmRzAOCOp1ehEhAzMO9oZMJWvCE1YG441X7h
voH/V+Gkor+SRqMcYF9SGTAlt8+iH412wx8mIENjLKAGELp3A5FDGaEp8FzwPFfA99CxKoDRBEA3
0MgiKoPPy7ZRTLCRgVQYcAOgPEyhfZGALknwAHDSX9AYMLNLnyPwX6BPkNFiMLIua9dUW9VPJgJT
yoEJgC0ZMGa+LWrgLK8tvy7PiWpkBRD/GjGxwNzisyazIqxFKoA3MP58Y7EOoJAg4WGJTN7P393z
NEDg4yA0kCDh7+L8SIn34LHg8R6QNuFT6K/pA4j/fyYgcFBQ0B5wdeEZo0ZROB44SCESAAAgR/Fz
KCt5rME0N0XQKQASEOzjLX+XmOVIBpA04IPgNXAFQGH2L+Xf399i8E/xXyW3HbELEDDrMDQJgDI0
Ni4ALmI1OTZmOGL/J3HoQD+QhMrwL/N/9InhYSfyb/jf9IlAQIPQNDKoMzUs7GAr/dM5/YK/H2FH
4ODAmSAN0M2JZLxQ9HAocRF1e5BisWdQSLJmXyNgZFEqdhHQJtB13/bQKtCQsWopVpBAmDba0Odc
sDpTecVpekfUmDuTun9KogLrjy7a0FgjoIaTyXNffPHvkP8xBGQp8WEC6S//g1hIMc2PjWEApaZW
e2KmgPtlIKoAKqZWNKB0kQJfg9DTuDINgigqmDYpAJ8BpNuswf9jKo8ul5grDY+NNP8Vb4/TEUR4
YpCTgriQMBvs/xFikFcRRJEXGz8b5xLfE++vAcIVRhFDEUMp7ll7t7r3DvwZIaagOySPIY8CASZ4
m/2U9jAs7YD+QTYwKfH//ZEXfw6fD68QvwK7G+hJwv3cgWUmeC9OCvBksM3AqXCUa1+vQHFXwigm
vpB/q6C+kKBg0LB24DLj7VBmewbQWeApJngSgx/z77AofxTSq6COMEfg+yCd0EqyJgAgTU9ERV9U
QfBSR0VUjZAkaRvXNpL0KCGQWHzksDp2kYCNkP4mN/A23zfvJHsb5kUwAEDyZVOhKCI9ia3HPKR3
khFIxSglZJeQXG4i3y8/G+Y8RBTSlwBvNVkb6f8yo3twMvZa8k0gM680v/1YWDczLPXQ/jI3I1Ax
f/4gKq8rvyzPLd8u7xvrIn+L1yezFNJC4kWPMD9Ty1zefTV//64CAx1kYjVZG9d/V68CIRqoWTtT
njaSaNBt/8YgWHOroKrDaLJhIe1QbCHyX3CQWkUjsD5PMkVStn+P4KbgNsNTf1SPVZ81ni/2KmZv
A2JTyTORsKmgzHH/kbh3wHNQv2HM4Jj4mDZnrz8MrEQ3SHGmkdTwT3QgPf+mR0+hNW8b4F7zAgGm
gtTw/48+b4ByXnBfG+CxQG9xIHqvAgE1XzZldbEhb4AwOMuHaDhuX29iTlVMTHcP/3Evcj9zQnuv
YZ9ir3dcZkn/G+Wm00clSECmW1laWX91r/9YhBlPHQo7aFlveByL/4C//4HPhuiHpskxsgCIASZ7
g2z/hI+Fn+9P+v/jn/rfmH+tOAH1NGIzM2U0MTH59gAxZPagv6DgwPav978/mp+bqvqfn9+bjP2S
OTN+Mv4SpQT9kf9nlrAzcGL/64CqoL6QIS8U1SZ5DMn1YG8JsQWQTBZBUGTgRU16aP53P9AL8SJy
p1+obqotzjDfzEKrT6xfrW+oqi2qLUyf/02vTrUjFIJPH+8g/xSvqKr+K7SPGB8i+rgNG9u5z7rf
/yJfI2Wun/9uajC17bLfxc/3/3ZHMM4xX2mAaXC2XsvS+8mvxppmt4C1g6sRaZDIX//EFs8mqIyW
v6Jv5yyiD9SvS/SPnRAzBbA5NfYAN/g1YTGdAPaPns/Wv9fNz6HP3C/Xzf2SMTUp0dnQ/94Q4XRL
w/71veIGiTMwBNHvtWTP9uNqC4QqC4PuWJHofjBcqWZYDOjiv+Wptcdf/GNiz/8BpxbJ6g/rH+wv
/wFOwL8b7BjvGfTzDxv/HQ//O3cj3xJW5N/l7IvtsQ+yEf9IoIgxXvOxsP2v+9/mCogw7/Zv92Pk
z+XYKXOPkrpnj/9o1pTRwoBbwLxgvfBqMIlgBm99QmAATlBJViB0VlAKZyg6IT+wzSBl+73wYLBh
nHAIr17z1QLmBP8KdQOdaNZPZwofWJENMolv/2N7bU4DJQTvBfp9Xwb/A9j/eo89UONqtiBO0e7w
MPkEI/8Yj3KfGX+S2ORzPIC7ghLyTwADXK/nT+DaOTilMjH/KlClle7V8WY88Dux9THjefhtYWtJ
EeSDkrp4M35g041992Vnbwrxb4/gI7//+0UrYm+Cvk8cbx1yWMW4b//3ZxdP8JoRweaDi+0u/7Xm
++RzWMYwOWIDnzNPNF/xA39jXCsvLD8tQbVkLX/hFTY0MzdLEDAm0p0ALDf/QrDiiMST42regHtA
5GwodtOLkT77a2a10GU4pFya/+jP7q87v/DFipPxP/JGwrD/KHHyz0//9J/1r0+P93/4j9/5n4bR
YOj+Ss8hdgZEWTOrAJ/+s1Px4kioY3OZgP+IQE6mAFGoYVn/TW/ykYqT/yOLAT8CTwNfBG9hbwaP
Gj/fWJ3kEMewvfDS8GnewR6Qr2jFkG9TRngyIZU3b8ew/l8M8KbCz+BOpsWQ+qpjl+sMsGzwcrZA
ItVFXEeLMP8tAKoQbRTRcGXAIJWUQGzBMFxcbiKL35HoLUVwUEVSTXMNSRmG7W13sDAM4I/wJmi2
OWPx8Hr4ZW9mv0BoxcWaHlRoxf4utYNtEHeQiDGKl3n/ewX/cQBs0XvMi7B8z3sFRSCm4AEcIkZD
X1BPUlRAX1JPTEVfgZBQAF9JTklUSUFUj4HQf597BWi0dHlwe/LpgZVUWXTAXwtygz97BfumlRaR
ZsKADOBqX4b7iHLdaJZjtdAdgU0waDljeAd/cv5r41kzbh9vK4sNiJFpH3GG46ZVYnK/c85OT0T+
RYZ+dfoITRB8Ee8Lc07w/8KwU2ETf5d9qYhjk1+GFpn/uz5ZMwBQqyGx4pNNX4Ye3/8f72Z/Y1ci
f1+Pau7x07vC/l+wwqGYu8I2LyUvavB2D/+n2yefKK9VYym/PdRkdqLEjYigYt6Qt4Bjb25pcORn
Zs1BdGZS2GDItAT3qYBFIBEhKrZztMu0Abvh/mP/0KOgX3B70fofsk1k/z/9TgkzVS1/D1NVVSJw
aPx5c73svh9jObhktyCj0MExcFsxMjhdPWzjMR8+cbx9nl/ydhaRTlVM/kzFT/6//8TH/6jVnxbR
8t9wd8qeyEw+MrA/cKLAr7S/qcB70XjBo5CIUNE0KeHwOzI/VDgmVWnURlbBIDz/Ptr+RFVg3pDj
MHkww4ERwMPDwRHAIiVzIsFRuNL/p29TRpiwFqDJIbhgMGDXc9gnQCeND2vycI6vj7v+VW0TCuKY
0pFRC3PbUa+hfYUwcv+AZcCS/3PMdNBSMYGwVFIodKCCoFZBbkzhPpZOw0ArmoAWoCf54PAwJ9jP
a2pEWtC413P6JsAZMdWv4g/jH+bf5+/90D8ow1HRtdzQ0npTf9PfP9TvPv/sb+1+Ib8WkWt6v4iw
mNGeQHj0uo+7lSkRwJRHRoKAS3TQTkXjyiVCFDYmoDIxJtE3Mv0nIDH+8Cdvr7+wzypPPm//P3/4
jy6PL58wrzGyVWjSr/86/0ufNX/IhKrfB784asAf/8Es8j8MHw0vTIk9XwPvBP9/QI/IW53kpdy8
fSM2XNF3c7x9zPlwY8wQouJFEHbVoGIoofJwcpB2Dw/O2/9sL20/V6gLtxCkdK4Ltxsv78hqSRkP
uKuIJqXVDYRWoesYiCsHOhiadkfILtaY0J9FMFGQAjHc0P2+OTb/YPtVQP8RNDmAQlBDXwFORR//
Ri+5X7pvYe8Z4LQBorAaQf8OUHkhVqG3O1Q2Oq+7lQ6V/1aSI5rF/8cNHe9Bj1s/H/X/XQ9CP18s
Q99H38lPylSp2X8gaaiozD8hvyLP7g+orXDfBeCpzxial0mYFE5xEGlg8nmYwGlikICj0HDQZeDy
d4VAd2HE4ZmxDeCIUP9cYVkxhUBV85CGV4ycqM8T+5CHDjFtGkCLwlsLI5/LXP9VF4wA4T5drzHA
oZhfL1Rf71VicHZWL/NxazGY+Hqs+AdE+M8QGJcxLjcuMcgwLjRqvn19GOBuUAAAHwBCAAEAAAAk
AAAARwBpAHIAaQBkAGgAYQByACAATQBhAGwAYQB2AGEAbABpAAAAHwBlAAEAAAA6AAAAZwBpAHIA
aQBkAGgAYQByAC4AbQBhAGwAYQB2AGEAbABpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwBk
AAEAAAAKAAAAUwBNAFQAUAAAAAAAAgFBAAEAAACAAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACA
RwBpAHIAaQBkAGgAYQByACAATQBhAGwAYQB2AGEAbABpAAAAUwBNAFQAUAAAAGcAaQByAGkAZABo
AGEAcgAuAG0AYQBsAGEAdgBhAGwAaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAJdAQAAADoA
AABnAGkAcgBpAGQAaABhAHIALgBtAGEAbABhAHYAYQBsAGkAQABxAGwAbwBnAGkAYwAuAGMAbwBt
AAAAAAAfAOVfAQAAAEIAAABzAGkAcAA6AGcAaQByAGkAZABoAGEAcgAuAG0AYQBsAGEAdgBhAGwA
aQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8AGgwBAAAAJAAAAEcAaQByAGkAZABoAGEAcgAg
AE0AYQBsAGEAdgBhAGwAaQAAAB8AHwwBAAAAOgAAAGcAaQByAGkAZABoAGEAcgAuAG0AYQBsAGEA
dgBhAGwAaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8AHgwBAAAACgAAAFMATQBUAFAAAAAA
AAIBGQwBAAAAgAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEcAaQByAGkAZABoAGEAcgAgAE0A
YQBsAGEAdgBhAGwAaQAAAFMATQBUAFAAAABnAGkAcgBpAGQAaABhAHIALgBtAGEAbABhAHYAYQBs
AGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwABXQEAAAA6AAAAZwBpAHIAaQBkAGgAYQByAC4A
bQBhAGwAYQB2AGEAbABpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwD4PwEAAAAkAAAARwBp
AHIAaQBkAGgAYQByACAATQBhAGwAYQB2AGEAbABpAAAAHwAjQAEAAAA6AAAAZwBpAHIAaQBkAGgA
YQByAC4AbQBhAGwAYQB2AGEAbABpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwAiQAEAAAAK
AAAAUwBNAFQAUAAAAAAAAgH5PwEAAACAAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACARwBpAHIA
aQBkAGgAYQByACAATQBhAGwAYQB2AGEAbABpAAAAUwBNAFQAUAAAAGcAaQByAGkAZABoAGEAcgAu
AG0AYQBsAGEAdgBhAGwAaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAldAQAAADoAAABnAGkA
cgBpAGQAaABhAHIALgBtAGEAbABhAHYAYQBsAGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAAAL
AEA6AQAAAB8AGgABAAAAEgAAAEkAUABNAC4ATgBvAHQAZQAAAAAAAwDxPwkEAAALAEA6AQAAAAMA
/T/kBAAAAgELMAEAAAAQAAAAEt2Xb8AxOEG6Iy8N9zCN/wMAFwABAAAAQAA5AIC5Xc8LEs8BQAAI
MGpjc88LEs8BCwApAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAAAAAUhQAAAQAAAAsAIwAAAAAA
HwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAHgAAAGEAYwBjAGUAcAB0AGwAYQBuAGcAdQBhAGcAZQAA
AAAAAQAAAAwAAABlAG4ALQBVAFMAAAALAACACCAGAAAAAADAAAAAAAAARgAAAAAGhQAAAAAAAB8A
NwABAAAAmgAAAFIAZQA6ACAAWwBQAEEAVABDAEgAXQAgAHEAbABhADIAeAB4AHgAOgAgAEMAbwBu
AGYAaQBnAHUAcgBlACAATgBQAEkAVgAgAGYAYwBfAHYAcABvAHIAdAAgAHYAaQBhACAAdABjAG0A
XwBxAGwAYQAyAHgAeAB4AF8AbgBwAGkAdgBfAG0AYQBrAGUAXwBsAHAAbwByAHQAAAAAAB8APQAB
AAAACgAAAFIAZQA6ACAAAAAAAAMANgAAAAAAAwAuAAAAAAAfAEIQAQAAAGwAAAA8ADEAMwA4ADkA
NwA2ADQANQAyADUALQAyADQANAA1ADMALQAxAC0AZwBpAHQALQBzAGUAbgBkAC0AZQBtAGEAaQBs
AC0AbgBhAGIAQABkAGEAdABlAHIAYQBpAG4AYwAuAGMAbwBtAD4AAAACAXEAAQAAABsAAAABAc8R
t2JzCECdgLBNTL5TM0hAkYV+moX0MN0AHwBwAAEAAACSAAAAWwBQAEEAVABDAEgAXQAgAHEAbABh
ADIAeAB4AHgAOgAgAEMAbwBuAGYAaQBnAHUAcgBlACAATgBQAEkAVgAgAGYAYwBfAHYAcABvAHIA
dAAgAHYAaQBhACAAdABjAG0AXwBxAGwAYQAyAHgAeAB4AF8AbgBwAGkAdgBfAG0AYQBrAGUAXwBs
AHAAbwByAHQAAAAAAB8ANRABAAAAZAAAADwAOQA4ADcAMAAzADkARAA2AC0AMQA5ADQAQwAtADQA
QwBCADIALQA5ADEAMABFAC0ANABGAEUARQBCAEIAOQA2ADMAMABCADkAQABxAGwAbwBnAGkAYwAu
AGMAbwBtAD4AAAAfADkQAQAAAGwAAAA8ADEAMwA4ADkANwA2ADQANQAyADUALQAyADQANAA1ADMA
LQAxAC0AZwBpAHQALQBzAGUAbgBkAC0AZQBtAGEAaQBsAC0AbgBhAGIAQABkAGEAdABlAHIAYQBp
AG4AYwAuAGMAbwBtAD4AAAADAN4/n04AAAMAgBD/////QAAHMOrdac8LEs8BAwAmAAAAAAACAUcA
AQAAAC4AAABjPVVTO2E9IDtwPVFMb2dpYztsPUFWTUIyLTE0MDExNTE2MDY1NVotNzgxNjEAAAAC
ARQwAQAAAAwAAADJAwAAsUgf3lMAAAAfAPo/AQAAACQAAABHAGkAcgBpAGQAaABhAHIAIABNAGEA
bABhAHYAYQBsAGkAAAADAA00/T8AAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACAAAAB4AC0AbQBz
AC0AaABhAHMALQBhAHQAdABhAGMAaAAAAAEAAAACAAAAAAAAAEro

--_000_987039D6194C4CB2910E4FEEBB9630B9qlogiccom_--
