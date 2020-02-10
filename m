Return-Path: <SRS0=AJIY=36=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84487C35254
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Feb 2020 19:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 458DC20661
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Feb 2020 19:29:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=seagate.com header.i=@seagate.com header.b="1mQH3RRo";
	dkim=pass (2048-bit key) header.d=seagate.com header.i=@seagate.com header.b="Xd9kZ/Sq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbgBJT31 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Feb 2020 14:29:27 -0500
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:9922 "EHLO
        mx0a-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727029AbgBJT31 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Feb 2020 14:29:27 -0500
X-Greylist: delayed 541 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Feb 2020 14:29:26 EST
Received: from pps.filterd (m0075553.ppops.net [127.0.0.1])
        by mx0a-00003501.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01AJIaws026733
        for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2020 14:20:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com; h=mime-version : from
 : date : message-id : subject : to : content-type :
 content-transfer-encoding; s=proofpoint;
 bh=32cRl0psfZlFIfgYEJUg/zrSsrp5gweGrD+uloloHgg=;
 b=1mQH3RRoEWlGJjZymsCSC4xv3W6N/R6hdUiPatdQd5pwAeQv8VhYBndggHd34iF2xpYR
 CCp4bd5CiAgRm8GRN5MhWgJPzjwauDNbVWYGRAnOlcwlPjH11xmTwI6VgOBYYF3r6vk+
 hS+bmztQ+otfVpPu4AyYHhoY4hC4vVmxcRG+OksTwUdoUfRUDYGtt7MwnMCHn7E4KZYl
 6DyOr9OP6c96Nk1GY0jhTNK1VjgG4CeDwEpHU8ZnPkIYtpYyIexNrh3FhfxyzT9+K3i/
 8vuhNKmfVjktPMNjnn5zDV3+rR/PJeEvYxsHrIdvSRBs5k8FFo/+diJuHsmZT03pGeWC 6A== 
Authentication-Results: seagate.com;
        dkim=pass header.s=google header.d=seagate.com
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        by mx0a-00003501.pphosted.com with ESMTP id 2y2b9yevdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2020 14:20:24 -0500
Received: by mail-wr1-f70.google.com with SMTP id u18so5496306wrn.11
        for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2020 11:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=seagate.com; s=google;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=32cRl0psfZlFIfgYEJUg/zrSsrp5gweGrD+uloloHgg=;
        b=Xd9kZ/SqKLDIWcPnfJQIgsPgcBCHbkQ/WeU9lluDf6gS51rNgiyGCuuTWnc33o3ywP
         XwF6aqDwi7KCs6V0rxnse0jSI+80WwP+TtgGxQAwUwafels9QZ6814iuPfzCFPLurW/L
         tVxNhPLr9DOgoX8i5yLlQKlXKgpGynrksBOklASKIoFjVbHmaQI5XdgrL5J/lhQlBqGG
         LCbeC/MvxP/L2lJpaLiXjGvIcYqnVVWZ/Dd3F3qwc5yLKqQxRfk55gAqWFkg16svVQVW
         rw8FwP6LEkX1ins9JvRe1MLyOsjE5XPJlg/RmkMM1zNStcidfQhSKaJC2sC/dRiT4diP
         KX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=32cRl0psfZlFIfgYEJUg/zrSsrp5gweGrD+uloloHgg=;
        b=c5p0QN1FXXfiiD14ayFkulsLeKN25NuGTLDh+sKTYsJGvToEv8s+JTxU2kjyfjFCtO
         qVghTfzBv6Yj9giyetlUEjWm/sUA7NBXIERXZ3fx+HwxeGi/H2gS3kTzwyESmV+C9BY6
         XNCgsyR7zozRlhzHtlfAsVdhuLeZCpSZ0in2yRuIgTSS86gadIDNDHvY7CZ4nZM8zbdW
         1p9uxetqhnf1IGPDcjtXhjhPr3bb2Nrmeox/q/Spbt72kNidM45vKimmbvitZRYKbrJq
         fXJQJunuSrfyVH1w/IuZIVhK+HxY2n8vXa/tZ6fziuw9rCOoKbuSHP6gnROzw5nMlLjO
         Hm5Q==
X-Gm-Message-State: APjAAAXTUTdeom2gV/ssjB9MYCaFW/bvrVXg7KlhilkU9fDYyBARaQgY
        Y6wQDXPAJ82w/ObnJG8OjVx9pV5BFWIWNt8FCtNWTHKv04XWhOATfzNn9zn+N8P7B06uEvGEwyG
        E6t3SESqnenU/B1FOatNWCydFnzubXjTW943NpiE3GRIR5HTl05R/cOl5F/Zzs4o=
X-Received: by 2002:a05:600c:2058:: with SMTP id p24mr460534wmg.96.1581362422477;
        Mon, 10 Feb 2020 11:20:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqzhho0hM0btYOROp4KxprD57xotc9dLtYEXfb79Mb66f6GNtPbrW35WAKNR4Bou5GMAW+EvJ4NgI1qm/L1c9iY=
X-Received: by 2002:a05:600c:2058:: with SMTP id p24mr460504wmg.96.1581362422072;
 Mon, 10 Feb 2020 11:20:22 -0800 (PST)
MIME-Version: 1.0
From:   Tim Walker <tim.t.walker@seagate.com>
Date:   Mon, 10 Feb 2020 14:20:10 -0500
Message-ID: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com>
Subject: [LSF/MM/BPF TOPIC] NVMe HDD
To:     linux-block@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-nvme@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-PolicyRoute: Outbound
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-10_07:2020-02-10,2020-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 clxscore=1011
 impostorscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=1 spamscore=0 adultscore=0 mlxlogscore=920 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002100143
X-Proofpoint-Spam-Policy: Default Domain Policy
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Background:

NVMe specification has hardened over the decade and now NVMe devices
are well integrated into our customers=E2=80=99 systems. As we look forward=
,
moving HDDs to the NVMe command set eliminates the SAS IOC and driver
stack, consolidating on a single access method for rotational and
static storage technologies. PCIe-NVMe offers near-SATA interface
costs, features and performance suitable for high-cap HDDs, and
optimal interoperability for storage automation, tiering, and
management. We will share some early conceptual results and proposed
salient design goals and challenges surrounding an NVMe HDD.


Discussion Proposal:

We=E2=80=99d like to share our views and solicit input on:

-What Linux storage stack assumptions do we need to be aware of as we
develop these devices with drastically different performance
characteristics than traditional NAND? For example, what schedular or
device driver level changes will be needed to integrate NVMe HDDs?

-Are there NVMe feature trade-offs that make sense for HDDs that won=E2=80=
=99t
break the HDD-SSD interoperability goals?

-How would upcoming multi-actuator HDDs impact NVMe?


Regards,
Tim Walker
