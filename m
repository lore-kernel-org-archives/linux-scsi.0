Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23FAEC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 08:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF47864F18
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 08:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhCRILP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 04:11:15 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:31000 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhCRILC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 04:11:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616055062; x=1647591062;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S1XpcZFQHtO6RkNE5yN3+4e98d2MqUJ14BzSQtqZCII=;
  b=jzdKvmdGAepCv7f+h2AeVO+PARbaMDwRxodU1oFII+3Knr9MCavtvYLL
   6COam89LuJEtJy63ChN877sn+AFeUIKlpPlGAYZkMSgZ4wJCsjaCl3wrV
   /ISfSZP0MNHEfqycx25oXYN2wHwFss1JIoRcNGR8qKRO0q4Zse3x6AvlR
   KyN+HBFsjJ1yVdaKNRNd909WgG/ZizX0DaTgpihc4bq+H7b1xbPpEBxWM
   PdVCbtd67/FInTT/7kByT4a5jG6DnVZ3zvDTH9KqsKsRxZIFCHTXTpiFD
   nBjEXrFRVDJMEgxPLKsHqpvTfCpZBPvSjRtc4lGBSEfp1/VzPqqdKfmNa
   w==;
IronPort-SDR: rLZrDTY104Su6o25/+re3TTcXEEAIOsof8bVHfBFkXZYyXdeZhEANLUYrBYYvqMQK4l+RzoUxc
 fhPkdEOs2ln0DmJjRx2QXJd+Jee6dMcVKlAREWRHfuItKkO+Z4ezMIB5A59pOuX5RRGyhposTJ
 4PJeecsvzEuLvzZIgb23qYSQKHY3M62BPf3eb9OSPVOO5Rs6aCcWBIkAbRPRi+uOg48KR84SmA
 SzPkZwhdNKbjqQaUu2XDVNGWtN3G3tJfpB0mBPyVMonBSioQfOJhsMh8s1fbxJwxAxEmNOcyqp
 Rbc=
X-IronPort-AV: E=Sophos;i="5.81,257,1610380800"; 
   d="scan'208";a="273171521"
Received: from mail-bn8nam11lp2177.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.177])
  by ob1.hgst.iphmx.com with ESMTP; 18 Mar 2021 16:11:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHuAYssOJN/4SMwgKUrWbB/pqybhmK2g40/1ii9xDU9usMbx21CQHYbbH9rOjFp32kBEFZZW37uEbMl1U6WAV2UC+THDov3z9MqLHV66LoP31ixGIoc/CI4/qH+OUbGz3OR265rsk4EFLkWPc60wIus5QplYkDFv077ffIdUotrE4j+YwkYIGvnWUR/aIHfaSKJGEy43bqTZeBijfc2CLCL1DLiAS8rTJesuOm8o0J+oHu+H+Iq7RJSqdWB0GOp5QW28FfsmkLzDuNtOYG2TuKBrMSNp6Tb4rqNln6LK26WAXpFqSC8LLzzQVEiK90Fc1mvp11sceW8XnhH3yRyfzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/mlaPzac+WOO6RRoGxqbNqgj/ApMRqbcsiAIUhYaEM=;
 b=fMlj3WtqtwRiLPyBd9KwAesWOMjKU1CEMORLZ61YdyWQNqOfyFiRm2/I0NUO26gV8UDIRbmS3nF/b2a/87Z1LNYDbEPLWYQERzW71YDX/iJVs4j5/VUsqB6AHEl7vxqwuxPUdaPwKj4AsMnSKrCuOE3lRnTIrZgDblzZm5+Jplz16fntFejns4C9h8jQY1bGVhkFqqRHV0O4K0H3Ya8wEcSYmsy1nlwFU9EgQSe5i9vuIJd//oJMKb1hwCaeHmmNn6Fz8K0bJwXCmVamZYujocH/FLmGF3LQa0j9BofbkuXXGE9IIbo8tTuaXHQrfT1XpbvAfCT+jmxpEozBqKOb1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/mlaPzac+WOO6RRoGxqbNqgj/ApMRqbcsiAIUhYaEM=;
 b=l9h2b7y3JmgapqJD6+Yj265W6jd3Mtlx0fXtRudtV17C8g+Vl/xjjQD2WcXVu67H2W2m7qVH/1DNnAoXcIzxO7txfDWriktdyISNreaaGPHTErjYuirL4/ZdBJCCCELA/H2FyRp6bTDjVvh3Y4FEfDl8md5IMWUCBVxRo1hY10E=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4026.namprd04.prod.outlook.com (2603:10b6:5:af::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18; Thu, 18 Mar 2021 08:10:57 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3955.018; Thu, 18 Mar 2021
 08:10:57 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Yue Hu <zbestahu@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "huyue2@yulong.com" <huyue2@yulong.com>,
        "zbestahu@163.com" <zbestahu@163.com>
Subject: RE: [PATCH v2] scsi: ufs: Tidy up WB configuration code
Thread-Topic: [PATCH v2] scsi: ufs: Tidy up WB configuration code
Thread-Index: AQHXG5hz1NzUwW1fXEGGT76FBnKcDKqJZHjg
Date:   Thu, 18 Mar 2021 08:10:57 +0000
Message-ID: <DM6PR04MB65756A57F0620AB2C107B349FC699@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210318014544.1976-1-zbestahu@gmail.com>
In-Reply-To: <20210318014544.1976-1-zbestahu@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bc9dccc0-bc63-42d3-5ac2-08d8e9e55c51
x-ms-traffictypediagnostic: DM6PR04MB4026:
x-microsoft-antispam-prvs: <DM6PR04MB40264B4AB3AFE128048C2BDBFC699@DM6PR04MB4026.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:369;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MJf0YBGbjlydAqH79EOHetcIxpkR1aXaY+Kjnz4Bbiqui0+aLvLmkXiId7dm5WpfF1DZw5+FKsIPhjt9cGCVnjKfwqPKXDRJqC2lpE1XP4TmtxmVi7+lZ0TMZOApUpwIv4uw6mLrnky7i9AavrLgqJ50mAhM99ojoJ0LDcD/5GAWF46u+8h+JLjBSE5rveR/5ThMjx4Td2qO5nAAP6jgERKvqwbHIUbfr+secexyyiVPMr8cP3rc15RYJ2c+HrUfVOiv4y0ShC2l0l74AQmrkfR+f32P0aO9U5WvHKKt1gbNVIvxP1qMvMSSdlgc44WOBZxpoAHL5wvYHzIfBYhEOrEjzCjFp9dq83S4ZB7pKmn7+XOD1yQSKkUKlEWnkGhTxhn6I4zDR2kNjRejyjQjj5U7XUpGkGJrjGpSl3GtdtChWWjeY51xkr+4H36H2bo7s1UFQNs0uTUwq5ZU/XxwqWM8b9YhdOg717RN/fDDgDuP/kdr2CtqcRndjihcsZYCzvCnX7DlHXfJex5FuGSDlDtKtbDyyb0y6oAnu0fYrR7x44eys5oWZH0OMoG5KVaICzDC+Fu5SE85+V3ZCQQn0LOzyT3ouf3PxjD8xQaX5WRp5ouqPIUacSlx9B0G3vWX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(376002)(136003)(366004)(66446008)(66476007)(66556008)(64756008)(7696005)(66946007)(55016002)(83380400001)(76116006)(316002)(71200400001)(8676002)(8936002)(478600001)(86362001)(26005)(186003)(54906003)(38100700001)(4326008)(33656002)(110136005)(52536014)(9686003)(6506007)(2906002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?rtAqqVk/kRXGhiBTaXkLXmoL63DJm0W5vaBXQZQLEkb9jqCIKN305jz3Dg6F?=
 =?us-ascii?Q?fpdL1MbIJePzELNOpv6OlHJnPRcXllCYgoAa+QkYNIMPLUtATTmkcPqnLymk?=
 =?us-ascii?Q?NYE8G+BE5V1ZeeJiCRmmh1IxyxXkfgJbHtqGjfmZXbrE2Vyd3Oe/LEi30DWc?=
 =?us-ascii?Q?JlwyLeSDQ6ou2Vay4T5Eni7Wpj9g6teHWBzttvUi4wXOpT0m6rjxUhy253zL?=
 =?us-ascii?Q?hf/pB5vURSgCG0b9yzPU1dk3Com6xEd8yraRz09gDCmMheKrlcOL87M+RsSd?=
 =?us-ascii?Q?ixBXidFA2eU03FHFT6X/fq93x5IJPS2WUefivZC/eibjK/1hAMNsBJy98f4y?=
 =?us-ascii?Q?qV5TTnayUJ77dyX/8B4LLiUx+TzlpCWyawQJ0vBEW1Kj6zcSWdk6awvwst0m?=
 =?us-ascii?Q?74uwxItaLNtlpcXhEjmhGieRPPfFPC5sCbLXD5oIw+G/M3PlIvQgYoW8WTDl?=
 =?us-ascii?Q?Hc2rrWyXd4UAIY19sHTSqDwacGlLgiCgR1rY/rlOZ4B6cu9IqwuevNFJPn+s?=
 =?us-ascii?Q?piSCkcNfQ+MTqrJ7ZL3xLjcxc93o+4a2AsQegAXQbqwT5ROwLvwL4zIbjRMi?=
 =?us-ascii?Q?Q7FT89jl4hS4jHWKXh0yloRz/aaTzwHj/7QHmSEOMyz8e5ck+/zqENDWHENN?=
 =?us-ascii?Q?yqNb1ix87jgYEcw2bCnKM34F51kCK0sAeU36CdQC72lLr8Iy8u0sy98jb9RL?=
 =?us-ascii?Q?z6Iw0p1yLpxWkEjbWX9HkVZesdRyyWTzlqeJeIhrgZA7CpJsPb1yevlBHxeq?=
 =?us-ascii?Q?w0mN6WJlCZGlPNH9/CAMNoPB16L21u38ocRF9xJhXhDnVzHkD7UyDu57ruvn?=
 =?us-ascii?Q?NV0PXW3xZAeNq6y1uG2vIDBg5eX1/Nxl4a//J1fX+yzL9aGn0UA9t2Xz2v8Z?=
 =?us-ascii?Q?yFz5MrZQGKIW3S0V7oAi+4ld4QU2h2lsrKh3SfuKlxc0ZK1m2dzMIuc30HiI?=
 =?us-ascii?Q?neT/IcbJaovNPiPzLkUb5QEOWSy9d3GlORVs2+qPrtgJPKhl6bQ/YkW9IUE7?=
 =?us-ascii?Q?fvUD+w2ymSdkyIitCe4eLefb5uwX1s9qBQezD2g4EQsjQi2nrdlXKL1Fz83d?=
 =?us-ascii?Q?PP239V0pTUQC5D+NKAZxRtGQDhp9GxvJbV5bX4tzuo+v4+WBQfBWbv3XGApB?=
 =?us-ascii?Q?ONEwCVFdUaCDV3YP3LhMmHBCDWwXop7KMQ2VA+0rUcvNfjn8jb8vBNFtB3f5?=
 =?us-ascii?Q?m4uyXgbl+th1RcK6feLwTtY/g4b2P6jX2GYWg/S3BsI5WH3Oc9kmYSsbJdj4?=
 =?us-ascii?Q?KlfkkWuCYD2/6YuJSSRMivL/Gji1KoVHnleAxk5q3LbuVlCfi3f10v9SG8pF?=
 =?us-ascii?Q?J1dxm9x7ULTDOppe5BpF3PZN?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc9dccc0-bc63-42d3-5ac2-08d8e9e55c51
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2021 08:10:57.6751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: moAgQqmu7AcqAzkElUmVsKuxlX7VSDdUb5lUm08h8x4LwKTqItFxXTpkzrUNVcTiXXsnruZz/hR3iY9qS6tVmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>=20
> -int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
> +static int __ufshcd_wb_toggle(struct ufs_hba *hba, bool set, enum flag_i=
dn
> idn)
>  {
> -       int ret;
>         u8 index;
>         enum query_opcode opcode;
What I meant is:
	enum query_opcode opcode =3D set ? UPIU_QUERY_OPCODE_SET_FLAG :=20
					       UPIU_QUERY_OPCODE_CLEAR_FLAG;

Either way, you can add my Reviewed-by tag.

Thanks,
Avri

>=20
> +       if (set)
> +               opcode =3D UPIU_QUERY_OPCODE_SET_FLAG;
> +       else
> +               opcode =3D UPIU_QUERY_OPCODE_CLEAR_FLAG;
> +
> +       index =3D ufshcd_wb_get_query_index(hba);
> +       return ufshcd_query_flag_retry(hba, opcode, idn, index, NULL);
> +}
> +
> +int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable)
> +{
> +       int ret;
> +
>         if (!ufshcd_is_wb_allowed(hba))
>                 return 0;
>=20
>         if (!(enable ^ hba->dev_info.wb_enabled))
>                 return 0;
> -       if (enable)
> -               opcode =3D UPIU_QUERY_OPCODE_SET_FLAG;
> -       else
> -               opcode =3D UPIU_QUERY_OPCODE_CLEAR_FLAG;
>=20
> -       index =3D ufshcd_wb_get_query_index(hba);
> -       ret =3D ufshcd_query_flag_retry(hba, opcode,
> -                                     QUERY_FLAG_IDN_WB_EN, index, NULL);
> +       ret =3D __ufshcd_wb_toggle(hba, enable, QUERY_FLAG_IDN_WB_EN);
>         if (ret) {
> -               dev_err(hba->dev, "%s write booster %s failed %d\n",
> +               dev_err(hba->dev, "%s Write Booster %s failed %d\n",
>                         __func__, enable ? "enable" : "disable", ret);
>                 return ret;
>         }
>=20
>         hba->dev_info.wb_enabled =3D enable;
> -       dev_dbg(hba->dev, "%s write booster %s %d\n",
> -                       __func__, enable ? "enable" : "disable", ret);
> +       dev_info(hba->dev, "%s Write Booster %s\n",
> +                       __func__, enable ? "enabled" : "disabled");
>=20
>         return ret;
>  }
>=20
> -static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool se=
t)
> +static void ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool s=
et)
>  {
> -       int val;
> -       u8 index;
> -
> -       if (set)
> -               val =3D  UPIU_QUERY_OPCODE_SET_FLAG;
> -       else
> -               val =3D UPIU_QUERY_OPCODE_CLEAR_FLAG;
> +       int ret;
>=20
> -       index =3D ufshcd_wb_get_query_index(hba);
> -       return ufshcd_query_flag_retry(hba, val,
> -                               QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBER=
N8,
> -                               index, NULL);
> +       ret =3D __ufshcd_wb_toggle(hba, set,
> +                       QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8);
> +       if (ret) {
> +               dev_err(hba->dev, "%s: WB-Buf Flush during H8 %s failed: =
%d\n",
> +                       __func__, set ? "enable" : "disable", ret);
> +               return;
> +       }
> +       dev_dbg(hba->dev, "%s WB-Buf Flush during H8 %s\n",
> +                       __func__, set ? "enabled" : "disabled");
>  }
>=20
> -static inline int ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enabl=
e)
> +static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enab=
le)
>  {
>         int ret;
> -       u8 index;
> -       enum query_opcode opcode;
>=20
>         if (!ufshcd_is_wb_allowed(hba) ||
>             hba->dev_info.wb_buf_flush_enabled =3D=3D enable)
> -               return 0;
> -
> -       if (enable)
> -               opcode =3D UPIU_QUERY_OPCODE_SET_FLAG;
> -       else
> -               opcode =3D UPIU_QUERY_OPCODE_CLEAR_FLAG;
> +               return;
>=20
> -       index =3D ufshcd_wb_get_query_index(hba);
> -       ret =3D ufshcd_query_flag_retry(hba, opcode,
> -                                     QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, in=
dex,
> -                                     NULL);
> +       ret =3D __ufshcd_wb_toggle(hba, enable,
> QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN);
>         if (ret) {
>                 dev_err(hba->dev, "%s WB-Buf Flush %s failed %d\n", __fun=
c__,
>                         enable ? "enable" : "disable", ret);
> -               goto out;
> +               return;
>         }
>=20
>         hba->dev_info.wb_buf_flush_enabled =3D enable;
>=20
> -       dev_dbg(hba->dev, "WB-Buf Flush %s\n", enable ? "enabled" : "disa=
bled");
> -out:
> -       return ret;
> -
> +       dev_dbg(hba->dev, "%s WB-Buf Flush %s\n",
> +                       __func__, enable ? "enabled" : "disabled");
>  }
>=20
>  static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 18e56c1..eddc819 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -1099,7 +1099,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba
> *hba,
>                              u8 *desc_buff, int *buff_len,
>                              enum query_opcode desc_op);
>=20
> -int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
> +int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
>=20
>  /* Wrapper functions for safely calling variant operations */
>  static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
> --
> 1.9.1

