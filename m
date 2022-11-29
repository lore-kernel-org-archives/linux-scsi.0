Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F43FC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Nov 2022 15:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbiK2PIA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Nov 2022 10:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiK2PH7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2022 10:07:59 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C53C765
        for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2022 07:07:58 -0800 (PST)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AT9pKfw007404;
        Tue, 29 Nov 2022 15:07:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=date : from : to :
 cc : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=qcppdkim1;
 bh=HXNOz10hCgntvzx1EXUh5R6xtCyov6qj2Ej5qYhv98o=;
 b=HNq94H7s0/5c5jnVVi9BNLaZvZiZKbzDpxctRhyBEbS67Aqq8VFOoRBZnWOolUWBfH2X
 OwODLgvMyTK7MWcA2m9STQf6AAIX0FrjpmbiqMIMYD9ewqZw9idV8GPqWEfhPWLURIYv
 sa/z4d8dmFTMaFr4VqtmPKkwWftVn9O35VpyBXCc22dw68c7lSN166kiTc6moArxeHkU
 V8njB+VLE9n9VSFCLxbfcxOr0CHQN9ODMHcGW84K/2mY7WhRJnVGGTtfP+u00/3+mUYR
 Q3nJOU8cOt9aGXBrkgijDhp7SGZ4zv8uOPn8NOisYgUkoRiDBg9v4kcAf1mJaG1PpAqk gg== 
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3m57p7j82a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 15:07:41 +0000
Received: from nasanex01a.na.qualcomm.com (corens_vlan604_snip.qualcomm.com [10.53.140.1])
        by NASANPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 2ATF7eou002136
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 15:07:40 GMT
Received: from asutoshd-linux1.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 29 Nov 2022 07:07:39 -0800
Date:   Tue, 29 Nov 2022 07:07:39 -0800
From:   Asutosh Das <quic_asutoshd@quicinc.com>
To:     Manivannan Sadhasivam <mani@kernel.org>
CC:     Powen Kao =?utf-8?B?KOmrmOS8r+aWhyk=?= <Powen.Kao@mediatek.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        Stanley Chu =?utf-8?B?KOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Peter Wang =?utf-8?B?KOeOi+S/oeWPiyk=?= 
        <peter.wang@mediatek.com>,
        Naomi Chu =?utf-8?B?KOacseipoOeUsCk=?= <Naomi.Chu@mediatek.com>,
        Alice Chao =?utf-8?B?KOi2meePruWdhyk=?= 
        <Alice.Chao@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <quic_cang@quicinc.com>
Subject: Re: 52a518019c causes issue with Qualcomm UFSHC
Message-ID: <20221129150739.GF20677@asutoshd-linux1.qualcomm.com>
References: <20221115014804.GA24294@asutoshd-linux1.qualcomm.com>
 <KL1PR03MB5836A982CAE0FE411743BF7283069@KL1PR03MB5836.apcprd03.prod.outlook.com>
 <20221117174634.GA12056@asutoshd-linux1.qualcomm.com>
 <584b6f9a-c4f9-8ecc-98d9-216923d85ddf@acm.org>
 <20221118191058.GA28646@asutoshd-linux1.qualcomm.com>
 <TYZPR03MB5825B4D5259FA22CCC876E7783089@TYZPR03MB5825.apcprd03.prod.outlook.com>
 <20221121225634.GA20677@asutoshd-linux1.qualcomm.com>
 <20221124053634.GB5119@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221124053634.GB5119@thinkpad>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 2BcPvcZqyerwlOVjqUmAFavBHqqaBzJH
X-Proofpoint-GUID: 2BcPvcZqyerwlOVjqUmAFavBHqqaBzJH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_10,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 impostorscore=0 spamscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290085
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 24 2022 at 21:36 -0800, Manivannan Sadhasivam wrote:
>On Mon, Nov 21, 2022 at 02:56:34PM -0800, Asutosh Das wrote:
>> On Sat, Nov 19 2022 at 20:16 -0800, Powen Kao (高伯文) wrote:
>> > Hi Asutosh,
>> >
>> >
>> >
>> > Reverting the patch doesn't sound feasible on MTK platform ☹
>> >
>> >
>> >
>> > > > I don't think invoking a clock scaling notification during
>> >
>> > > > ufshcd_host_reset_and_restore() sounds right to me.
>> >
>> > But the point is that driver has the right to know that the clk is scaled no matter where ufshcd_scale_clks() is invoked, no?
>> >
>> >
>> >
>> > Do you mind applying this patch on qcom driver to check on host status before further operation?
>>
>> + Mani, linux-scsi
>>
>> Hello Powen
>> Thanks for the change. I will think of something to work-around the issue.
>> However, I would like to point out that a change that breaks an existing driver
>> must be fixed or reverted, not the other way around.
>>
>
>May I know what the actual issue is? I've tested v6.1-rc1 that has this change
>and didn't see any issues on SM8250, SDM845 and SM8450.
>
>Thanks,
>mani
>
Set rpm-lvl=5, enable scaling and let it enter runtime-suspend and then resume.
You should see the CMD17 timeout.

-asd
>>
>
>-- 
>மணிவண்ணன் சதாசிவம்
