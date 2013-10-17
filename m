From: "lindar_liu" <lindar_liu@usish.com>
Subject: RE: [PATCH Resend] [scsi] pm8001 : fix panic when cat /sys/class/sas_phy/phy-8:0/running_disparity_error_count
Date: Thu, 17 Oct 2013 11:37:36 +0800
Message-ID: <003a01cecaea$3c98fbe0$b5caf3a0$@com>
References: <33d91895.262d9.141c17a5a04.Coremail.zxh3737@163.com> <003901cecae6$1ee5f980$5cb1ec80$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:45996 "EHLO msb01.usish.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761822Ab3JQDrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Oct 2013 23:47:21 -0400
In-Reply-To: <003901cecae6$1ee5f980$5cb1ec80$@com>
Content-Language: zh-cn
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'zxh3737' <zxh3737@163.com>, linux-scsi@vger.kernel.org
Cc: asanthan@gmail.com, Sangeetha.Gnanasekaran@pmcs.com

>
diff=A0--git=A0a/drivers/scsi/pm8001/pm80xx_hwi.c=A0b/drivers/scsi/pm80=
01/pm80xx_h
> wi.c index=A09f91030..c0ea473=A0100644
> ---=A0a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++=A0b/drivers/scsi/pm8001/pm80xx_hwi.c
>
@@=A0-3076,8=A0+3076,43=A0@@=A0static=A0int=A0mpi_get_controller_config=
_resp(struct=A0pm80
> 01_hba_info=A0*pm8001_ha,
> =A0static=A0int=A0mpi_get_phy_profile_resp(struct=A0pm8001_hba_info=A0=
*pm8001_ha,
> =A0 void=A0*piomb)
> =A0{
> - PM8001_MSG_DBG(pm8001_ha,
> - pm8001_printk("=A0pm80xx_addition_functionality\n"));
> + u8=A0page_code;
> + struct=A0get_phy_profile_resp=A0*pPayload=A0=3D (struct=A0get_phy_p=
rofile_resp
> + *)(piomb=A0+=A04);
> + u32=A0ppc_phyid=A0=3D=A0le32_to_cpu(pPayload->ppc_phyid);
> + u32=A0status=A0=3D=A0le32_to_cpu(pPayload->status);
> + u8=A0phy_id=A0=3D=A0(u8)(ppc_phyid=A0&=A00x00FF);
> + page_code=A0=3D=A0(u8)((ppc_phyid=A0&=A00xFF00)=A0>>=A08); struct=A0=
asd_sas_phy
> + *sas_phy=A0=3D &(pm8001_ha->phy[phy_id].sas_phy);
> + struct=A0sas_phy=A0*phy=A0=3D=A0sas_phy->phy;
> +
> + if=A0(status)=A0{
> + /*=A0status=A0is=A0FAILED=A0*/
> + PM8001_FAIL_DBG(pm8001_ha,
> + pm8001_printk("PhyProfile=A0command=A0failed=A0=A0with=A0status=A0"
> + "0x%08X=A0\n",=A0status));
> + return=A0-1;
> + }=A0else=A0{
> + switch=A0(page_code)=A0{
> + case=A0SAS_PHY_ERROR_PAGE:
> + phy->invalid_dword_count=A0=3D
> + le32_to_cpu(pPayload->ppc_specific_rsp[0]);
> + phy->running_disparity_error_count=A0=3D
> + le32_to_cpu(pPayload->ppc_specific_rsp[1]);
> + phy->loss_of_dword_sync_count=A0=3D
> + le32_to_cpu(pPayload->ppc_specific_rsp[3]);
> + phy->phy_reset_problem_count=A0=3D
> + le32_to_cpu(pPayload->ppc_specific_rsp[4]);
> + complete(pm8001_ha->phy[phy_id].enable_completion);
> + break;
> + default:
> + PM8001_MSG_DBG(pm8001_ha,
> + pm8001_printk("other=A0page=A0code=A00x%X\n", page_code)); break; }=
 }
>=20
> =A0 return=A00;
> =A0}

Any failure response also need to call complete() function.=20
You can put the "complete()" at end before return.

Thanks.
Lindar

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
