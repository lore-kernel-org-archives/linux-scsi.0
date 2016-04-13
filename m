From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: [PATCH v14 6/9] added support for DesignWare Controller
Date: Wed, 13 Apr 2016 13:57:42 +0100
Message-ID: <570E4246.8040504@synopsys.com>
References: <cover.1459448160.git.jpinto@synopsys.com>
 <75cb43b16231f67d1e94e174a45ad6ffc68e1df6.1459448160.git.jpinto@synopsys.com>
 <CAC5umyiSCeBMMwdxo2SqteVNjOtTPqO6g-KQ-Ebta_QFR0pX2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:56628 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586AbcDMM6D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2016 08:58:03 -0400
In-Reply-To: <CAC5umyiSCeBMMwdxo2SqteVNjOtTPqO6g-KQ-Ebta_QFR0pX2A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, Joao Pinto <Joao.Pinto@synopsys.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


Hi Akinobu,

On 4/13/2016 1:19 PM, Akinobu Mita wrote:
> Hi Joao,
> 
> 2016-04-13 18:04 GMT+09:00 Joao Pinto <Joao.Pinto@synopsys.com>:
> 
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index e3931d0..c780d14 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -263,6 +263,7 @@ struct ufs_pwr_mode_info {
>>   * @suspend: called during host controller PM callback
>>   * @resume: called during host controller PM callback
>>   * @dbg_register_dump: used to dump controller debug information
>> + * @phy_initialization: used to initialize phys
>>   */
>>  struct ufs_hba_variant_ops {
>>         const char *name;
>> @@ -284,6 +285,7 @@ struct ufs_hba_variant_ops {
>>         int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
>>         int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
>>         void    (*dbg_register_dump)(struct ufs_hba *hba);
>> +       int     (*phy_initialization)(struct ufs_hba *);
>>  };
> 
> This vops->phy_initialization is only called from ufs dwc specific
> source files and not called from ufs core.  So this should not belong
> to ufs_hba_variant_ops.

At this time only DWC specific uses the phy_initialization, but can be used by
others in the future when the same necessity comes.

> 
> You can use hba->priv to put the controller specific data structure
> including phy_initialization and you also need to define vops->init
> callback which allocates and initialize the data structure.
> 

Joao

