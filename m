Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ONMAMGe1"
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D7EC1
	for <linux-scsi@vger.kernel.org>; Mon,  4 Dec 2023 11:46:40 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-5b4e3284e68so6410737b3.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 Dec 2023 11:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701719199; x=1702323999; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C7Onnnu1d3L3SGzaSO5M5Z2cYY/iFwA7SEpxAHi5fZY=;
        b=ONMAMGe1YPNklHfA7tWXrTUt5+VxPZBsIudzoaZ4eRV+dc8a7EAYE8nwBvsNF7Dui1
         mRFkEjgHNY658gKq5mGTJwmM6Id1cLdo0ylQo0yNY6BMnC+rLLHe6jrv4FCH9eVJe7OW
         zzogN/Dom0iinWOanyhnFPbcv/GoeC3GNVIndDOmsScr0EE/WqDPzw+RXLeEUYnXWBpT
         tgaBkco4OYG9+ct5atQgoEhU0+TrB4RKO8nySC9vojckq5Q91IF/DMkFPV+2Iq79bN9x
         eh4a3CsFy/HGG6UBKBmt0yoTeW3mnAJ/5GplpnRF/aBs8wrxLpyAEKzc7EKnOhrOSQom
         bxaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701719199; x=1702323999;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C7Onnnu1d3L3SGzaSO5M5Z2cYY/iFwA7SEpxAHi5fZY=;
        b=qhLPooSWsXPq95NwXIjJjsyE4RXIFdcrWQGKV4gLSpQNCRbfAsYxQcvJ0aXt54XJ4i
         CwT1ZjN/OhKAeM0vjRr3uo5jYb++/H7hw/wyQ6oacj0kA0bJ95nwJT9JNWH128JvRYNR
         E1dydc0ZHoJmZyCxBlY3xzsxCzj0hMWeavXRk7ZnmCja1xBRBpf5TI1fZuWzQMs1q2K6
         uj3bQ6Pic5JKE9k2Nq6bPYaKVX58gzZj2q4az05lY80gNPJz6wP2LatgBWTnZOi4oSyv
         hUlGojszeuSRGm72Eh5mZoKPpCwHG2hOUvTi2FoMD2Q6FM+2/4OpXVK2C1D5yjldiuxc
         i4yQ==
X-Gm-Message-State: AOJu0YwHOOBu6ZciWakoijn7N28dIlSt4J4Q+z5jJRkOHaFICTOuwq8N
	9kVEndGBbyhmfeE2OwXOfNgGrO9wIdq505vlQDA=
X-Google-Smtp-Source: AGHT+IEIFJ7SCYJZ8nwvZk/X4zcofwDKPPY9qLhImbvuYQyLZPoOQgbwPxFOPw3hK0W7pjx7QNPadCgBZvxghJt9HKM=
X-Received: by 2002:a0d:d68d:0:b0:5d4:1d55:b677 with SMTP id
 y135-20020a0dd68d000000b005d41d55b677mr7397810ywd.5.1701719199124; Mon, 04
 Dec 2023 11:46:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <121b7df5-8277-497a-983a-eac00061fb58@moroto.mountain>
In-Reply-To: <121b7df5-8277-497a-983a-eac00061fb58@moroto.mountain>
From: Justin Tee <justintee8345@gmail.com>
Date: Mon, 4 Dec 2023 11:46:28 -0800
Message-ID: <CABPRKS_8MuDTA3oTXdt+ib_Zaba1iD3xN5ZZFM7fOAFCDBFj6A@mail.gmail.com>
Subject: Re: [bug report] scsi: lpfc: Add support for the CM framework
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: jsmart2021@gmail.com, Dick Kennedy <dick.kennedy@broadcom.com>, 
	Justin Tee <justin.tee@broadcom.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dan,

Line 8301 sets sli4_params->cmf equal to 0.  So, =E2=80=9Cif (sli4_params->=
cmf
&& sli4_params->mi_ver) {=E2=80=9C on line 8338 would not evaluate to true =
and
we would not reach the line 8343 in question.

    8288                 /* Allocate Congestion Information Buffer */
    8289                 if (!phba->cgn_i) {
    8290                         mp =3D kmalloc(sizeof(*mp), GFP_KERNEL);
    8291                         if (mp)
    8292                                 mp->virt =3D dma_alloc_coherent
    8293                                                 (&phba->pcidev->de=
v,
    8294                                                 sizeof(struct
lpfc_cgn_info),
    8295                                                 &mp->phys, GFP_KER=
NEL);
    8296                         if (!mp || !mp->virt) {
    8297                                 lpfc_printf_log(phba,
KERN_ERR, LOG_INIT,
    8298                                                 "2640 Failed
to alloc memory "
    8299                                                 "for
Congestion Info\n");
    8300                                 kfree(mp);
    8301                                 sli4_params->cmf =3D 0;
    8302                                 phba->cmf_active_mode =3D LPFC_CFG=
_OFF;
    8303                                 goto no_cmf;
=E2=80=A6
    8329         } else {
    8330 no_cmf:
    8331                 lpfc_printf_log(phba, KERN_WARNING, LOG_CGN_MGMT,
    8332                                 "6220 CMF is disabled\n");
    8333         }
    8334
    8335         /* Only register congestion buffer with firmware if BOTH
    8336          * CMF and E2E are enabled.
    8337          */
    8338         if (sli4_params->cmf && sli4_params->mi_ver) {
    8339                 rc =3D lpfc_reg_congestion_buf(phba);
    8340                 if (rc) {
    8341                         dma_free_coherent(&phba->pcidev->dev,
    8342                                           sizeof(struct lpfc_cgn_i=
nfo),
--> 8343                                           phba->cgn_i->virt,
phba->cgn_i->phys);
                                                   ^^^^^^^^^^^^^^^^^

Regards,
Justin

On Mon, Dec 4, 2023 at 4:31=E2=80=AFAM Dan Carpenter <dan.carpenter@linaro.=
org> wrote:
>
> [ I'm not sure what triggered this warning 2 years after the commit.
>   I checked on lore but I've never reported it previously. -dan ]
>
> Hello James Smart,
>
> The patch 02243836ad6f: "scsi: lpfc: Add support for the CM
> framework" from Aug 16, 2021 (linux-next), leads to the following
> Smatch static checker warning:
>
>         drivers/scsi/lpfc/lpfc_sli.c:8343 lpfc_cmf_setup()
>         error: we previously assumed 'phba->cgn_i' could be null (see lin=
e 8289)
>
> drivers/scsi/lpfc/lpfc_sli.c
>     8203 static int
>     8204 lpfc_cmf_setup(struct lpfc_hba *phba)
>     8205 {
>     8206         LPFC_MBOXQ_t *mboxq;
>     8207         struct lpfc_dmabuf *mp;
>     8208         struct lpfc_pc_sli4_params *sli4_params;
>     8209         int rc, cmf, mi_ver;
>     8210
>     8211         rc =3D lpfc_sli4_refresh_params(phba);
>     8212         if (unlikely(rc))
>     8213                 return rc;
>     8214
>     8215         mboxq =3D (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_p=
ool, GFP_KERNEL);
>     8216         if (!mboxq)
>     8217                 return -ENOMEM;
>     8218
>     8219         sli4_params =3D &phba->sli4_hba.pc_sli4_params;
>     8220
>     8221         /* Always try to enable MI feature if we can */
>     8222         if (sli4_params->mi_ver) {
>     8223                 lpfc_set_features(phba, mboxq, LPFC_SET_ENABLE_M=
I);
>     8224                 rc =3D lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL=
);
>     8225                 mi_ver =3D bf_get(lpfc_mbx_set_feature_mi,
>     8226                                  &mboxq->u.mqe.un.set_feature);
>     8227
>     8228                 if (rc =3D=3D MBX_SUCCESS) {
>     8229                         if (mi_ver) {
>     8230                                 lpfc_printf_log(phba,
>     8231                                                 KERN_WARNING, LO=
G_CGN_MGMT,
>     8232                                                 "6215 MI is enab=
led\n");
>     8233                                 sli4_params->mi_ver =3D mi_ver;
>     8234                         } else {
>     8235                                 lpfc_printf_log(phba,
>     8236                                                 KERN_WARNING, LO=
G_CGN_MGMT,
>     8237                                                 "6338 MI is disa=
bled\n");
>     8238                                 sli4_params->mi_ver =3D 0;
>     8239                         }
>     8240                 } else {
>     8241                         /* mi_ver is already set from GET_SLI4_P=
ARAMETERS */
>     8242                         lpfc_printf_log(phba, KERN_INFO,
>     8243                                         LOG_CGN_MGMT | LOG_INIT,
>     8244                                         "6245 Enable MI Mailbox =
x%x (x%x/x%x) "
>     8245                                         "failed, rc:x%x mi:x%x\n=
",
>     8246                                         bf_get(lpfc_mqe_command,=
 &mboxq->u.mqe),
>     8247                                         lpfc_sli_config_mbox_sub=
sys_get
>     8248                                                 (phba, mboxq),
>     8249                                         lpfc_sli_config_mbox_opc=
ode_get
>     8250                                                 (phba, mboxq),
>     8251                                         rc, sli4_params->mi_ver)=
;
>     8252                 }
>     8253         } else {
>     8254                 lpfc_printf_log(phba, KERN_WARNING, LOG_CGN_MGMT=
,
>     8255                                 "6217 MI is disabled\n");
>     8256         }
>     8257
>     8258         /* Ensure FDMI is enabled for MI if enable_mi is set */
>     8259         if (sli4_params->mi_ver)
>     8260                 phba->cfg_fdmi_on =3D LPFC_FDMI_SUPPORT;
>     8261
>     8262         /* Always try to enable CMF feature if we can */
>     8263         if (sli4_params->cmf) {
>     8264                 lpfc_set_features(phba, mboxq, LPFC_SET_ENABLE_C=
MF);
>     8265                 rc =3D lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL=
);
>     8266                 cmf =3D bf_get(lpfc_mbx_set_feature_cmf,
>     8267                              &mboxq->u.mqe.un.set_feature);
>     8268                 if (rc =3D=3D MBX_SUCCESS && cmf) {
>     8269                         lpfc_printf_log(phba, KERN_WARNING, LOG_=
CGN_MGMT,
>     8270                                         "6218 CMF is enabled: mo=
de %d\n",
>     8271                                         phba->cmf_active_mode);
>     8272                 } else {
>     8273                         lpfc_printf_log(phba, KERN_WARNING,
>     8274                                         LOG_CGN_MGMT | LOG_INIT,
>     8275                                         "6219 Enable CMF Mailbox=
 x%x (x%x/x%x) "
>     8276                                         "failed, rc:x%x dd:x%x\n=
",
>     8277                                         bf_get(lpfc_mqe_command,=
 &mboxq->u.mqe),
>     8278                                         lpfc_sli_config_mbox_sub=
sys_get
>     8279                                                 (phba, mboxq),
>     8280                                         lpfc_sli_config_mbox_opc=
ode_get
>     8281                                                 (phba, mboxq),
>     8282                                         rc, cmf);
>     8283                         sli4_params->cmf =3D 0;
>     8284                         phba->cmf_active_mode =3D LPFC_CFG_OFF;
>     8285                         goto no_cmf;
>     8286                 }
>     8287
>     8288                 /* Allocate Congestion Information Buffer */
>     8289                 if (!phba->cgn_i) {
>     8290                         mp =3D kmalloc(sizeof(*mp), GFP_KERNEL);
>     8291                         if (mp)
>     8292                                 mp->virt =3D dma_alloc_coherent
>     8293                                                 (&phba->pcidev->=
dev,
>     8294                                                 sizeof(struct lp=
fc_cgn_info),
>     8295                                                 &mp->phys, GFP_K=
ERNEL);
>     8296                         if (!mp || !mp->virt) {
>     8297                                 lpfc_printf_log(phba, KERN_ERR, =
LOG_INIT,
>     8298                                                 "2640 Failed to =
alloc memory "
>     8299                                                 "for Congestion =
Info\n");
>     8300                                 kfree(mp);
>     8301                                 sli4_params->cmf =3D 0;
>     8302                                 phba->cmf_active_mode =3D LPFC_C=
FG_OFF;
>     8303                                 goto no_cmf;
>
> phba->cgn_i is NULL here.
>
>     8304                         }
>     8305                         phba->cgn_i =3D mp;
>     8306
>     8307                         /* initialize congestion buffer info */
>     8308                         lpfc_init_congestion_buf(phba);
>     8309                         lpfc_init_congestion_stat(phba);
>     8310
>     8311                         /* Zero out Congestion Signal counters *=
/
>     8312                         atomic64_set(&phba->cgn_acqe_stat.alarm,=
 0);
>     8313                         atomic64_set(&phba->cgn_acqe_stat.warn, =
0);
>     8314                 }
>     8315
>     8316                 rc =3D lpfc_sli4_cgn_params_read(phba);
>     8317                 if (rc < 0) {
>     8318                         lpfc_printf_log(phba, KERN_ERR, LOG_CGN_=
MGMT | LOG_INIT,
>     8319                                         "6242 Error reading Cgn =
Params (%d)\n",
>     8320                                         rc);
>     8321                         /* Ensure CGN Mode is off */
>     8322                         sli4_params->cmf =3D 0;
>     8323                 } else if (!rc) {
>     8324                         lpfc_printf_log(phba, KERN_ERR, LOG_CGN_=
MGMT | LOG_INIT,
>     8325                                         "6243 CGN Event empty ob=
ject.\n");
>     8326                         /* Ensure CGN Mode is off */
>     8327                         sli4_params->cmf =3D 0;
>     8328                 }
>     8329         } else {
>     8330 no_cmf:
>     8331                 lpfc_printf_log(phba, KERN_WARNING, LOG_CGN_MGMT=
,
>     8332                                 "6220 CMF is disabled\n");
>     8333         }
>     8334
>     8335         /* Only register congestion buffer with firmware if BOTH
>     8336          * CMF and E2E are enabled.
>     8337          */
>     8338         if (sli4_params->cmf && sli4_params->mi_ver) {
>     8339                 rc =3D lpfc_reg_congestion_buf(phba);
>     8340                 if (rc) {
>     8341                         dma_free_coherent(&phba->pcidev->dev,
>     8342                                           sizeof(struct lpfc_cgn=
_info),
> --> 8343                                           phba->cgn_i->virt, phb=
a->cgn_i->phys);
>                                                    ^^^^^^^^^^^^^^^^^
> Unchecked dereference.
>
>     8344                         kfree(phba->cgn_i);
>     8345                         phba->cgn_i =3D NULL;
>     8346                         /* Ensure CGN Mode is off */
>     8347                         phba->cmf_active_mode =3D LPFC_CFG_OFF;
>     8348                         sli4_params->cmf =3D 0;
>     8349                         return 0;
>     8350                 }
>     8351         }
>     8352         lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
>     8353                         "6470 Setup MI version %d CMF %d mode %d=
\n",
>     8354                         sli4_params->mi_ver, sli4_params->cmf,
>     8355                         phba->cmf_active_mode);
>     8356
>     8357         mempool_free(mboxq, phba->mbox_mem_pool);
>     8358
>     8359         /* Initialize atomic counters */
>     8360         atomic_set(&phba->cgn_fabric_warn_cnt, 0);
>     8361         atomic_set(&phba->cgn_fabric_alarm_cnt, 0);
>     8362         atomic_set(&phba->cgn_sync_alarm_cnt, 0);
>     8363         atomic_set(&phba->cgn_sync_warn_cnt, 0);
>     8364         atomic_set(&phba->cgn_driver_evt_cnt, 0);
>     8365         atomic_set(&phba->cgn_latency_evt_cnt, 0);
>     8366         atomic64_set(&phba->cgn_latency_evt, 0);
>     8367
>     8368         phba->cmf_interval_rate =3D LPFC_CMF_INTERVAL;
>     8369
>     8370         /* Allocate RX Monitor Buffer */
>     8371         if (!phba->rx_monitor) {
>     8372                 phba->rx_monitor =3D kzalloc(sizeof(*phba->rx_mo=
nitor),
>     8373                                            GFP_KERNEL);
>     8374
>     8375                 if (!phba->rx_monitor) {
>     8376                         lpfc_printf_log(phba, KERN_ERR, LOG_INIT=
,
>     8377                                         "2644 Failed to alloc me=
mory "
>     8378                                         "for RX Monitor Buffer\n=
");
>     8379                         return -ENOMEM;
>     8380                 }
>     8381
>     8382                 /* Instruct the rx_monitor object to instantiate=
 its ring */
>     8383                 if (lpfc_rx_monitor_create_ring(phba->rx_monitor=
,
>     8384                                                 LPFC_MAX_RXMONIT=
OR_ENTRY)) {
>     8385                         kfree(phba->rx_monitor);
>     8386                         phba->rx_monitor =3D NULL;
>     8387                         lpfc_printf_log(phba, KERN_ERR, LOG_INIT=
,
>     8388                                         "2645 Failed to alloc me=
mory "
>     8389                                         "for RX Monitor's Ring\n=
");
>     8390                         return -ENOMEM;
>     8391                 }
>     8392         }
>     8393
>     8394         return 0;
>     8395 }
>
> regards,
> dan carpenter
>
