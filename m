Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555F4C636CC
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Feb 2023 11:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjBGLUV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Feb 2023 06:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjBGLUT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2023 06:20:19 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAB2126F5
        for <linux-scsi@vger.kernel.org>; Tue,  7 Feb 2023 03:20:17 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 317BEKr6030464
        for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2023 03:20:17 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3nhqrtjxjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 07 Feb 2023 03:20:16 -0800
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 317Aj9oV010082
        for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2023 03:20:15 -0800
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3nhqrtjxja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 03:20:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XNtswqu7AfURXsp8TDO2mmwqjgM4epn/38OYn4q5CcwiodEJIsZJhaMHWmJraZvnmvhbFn6VPkMC8iT8RoRXHguhotx15G20LBogdIF6OjA0Y4GCEp6TfliEYXR2Jg+qIWkR1w6DEnHS48d0DdtzHOY8oPcvliJ8KbfeSqBFHbDULQebhC4v0zhlc5+dNPkCRp1GSQCjYfavPQ4Fn6UCDga94en9CRQkMKV2wylu31JrFdV6rvYkef6Tp6plbB16q3xkiTOeWR4vFvDDdt3WKbeuBNVTFel59uIk9sFlk0DJbN5wKF5/rPy1TUFJ9Dlga91qf86XaWeVGmpee8DYKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M6gM7TiaUUiOJqYaDXkX7z4d6lhIuDEnGlndTXnpQ40=;
 b=alF/TJ9F8hEzu8mTky6UON3jan9Ht+BNOlRLz158t50fNFpiXvcGF3yUL4lT9aZowzhkT1Faza34XpMSt33OO1vyAzOalxH28X46jAGdhmwpYCkzVdGI5PpsOKnLoSZzPjixJMlTNNqgQRz4A18gGWrw7LoDVAvT25wW4NbVTTS4FHegAoPv4/JYtaKileC1/4kKRFH0Qk/2YG224t7zn8UdAaeBVnMz5w8N9+//EOMV/Aue0FK8yExTRBOr+/1LfS19H/W2OBHLF+bfdnR8P+bGu7L0/wWbcBIU0pQNMOStvZYd5S6uae9qUpbVw9ZgnTRb7gyUiaPRVyj29fDKMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M6gM7TiaUUiOJqYaDXkX7z4d6lhIuDEnGlndTXnpQ40=;
 b=bjeip+a5Mik5sLuPCg8G7hNIoGBH7JYGezHHwoU2PEVa0ajD+RucDZqe5N0DGttMoez8qwx+Bu2Dmklhjwa0N4ouzk3drIY5eDqCQ/p2qpCzxE5ogi9POuGJb6iWGHogn1X6CJuWuMM4ob7l92zixKyfTv4lOybxmShcuuNZVQA=
Received: from DM4PR18MB5220.namprd18.prod.outlook.com (2603:10b6:8:53::16) by
 MW3PR18MB3658.namprd18.prod.outlook.com (2603:10b6:303:54::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.35; Tue, 7 Feb 2023 11:20:12 +0000
Received: from DM4PR18MB5220.namprd18.prod.outlook.com
 ([fe80::bbcc:7359:7a4d:3e3b]) by DM4PR18MB5220.namprd18.prod.outlook.com
 ([fe80::bbcc:7359:7a4d:3e3b%3]) with mapi id 15.20.6064.036; Tue, 7 Feb 2023
 11:20:12 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Girish Basrur <gbasrur@marvell.com>
Subject: IO error on DIF/DIX supported array
Thread-Topic: IO error on DIF/DIX supported array
Thread-Index: Adk65h58aAJPomO/QEKOGTaF0/rqJA==
Date:   Tue, 7 Feb 2023 11:20:11 +0000
Message-ID: <DM4PR18MB5220E0AF6564DF1A1F126EF0D2DB9@DM4PR18MB5220.namprd18.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2thc2h5YXBc?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy02MGY1MmRmZi1hNmQ5LTExZWQtOTUxNi00ODJh?=
 =?us-ascii?Q?ZTM1NzAzZTVcYW1lLXRlc3RcNjBmNTJlMDAtYTZkOS0xMWVkLTk1MTYtNDgy?=
 =?us-ascii?Q?YWUzNTcwM2U1Ym9keS50eHQiIHN6PSI1NjQyIiB0PSIxMzMyMDI0MjQwOTc4?=
 =?us-ascii?Q?NjAzOTUiIGg9IkViVnBmM1h2QTEvRitOckpaK3RMSEJXMFZDdz0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUhZSUFB?=
 =?us-ascii?Q?QXI2NUlqNWpyWkFYOWJnUDlERXdCRmYxdUEvME1UQUVVTkFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQUFHQ0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRQUJBQUFBbk5Ca3B3QUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFa?=
 =?us-ascii?Q?QUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4QWNB?=
 =?us-ascii?Q?QmxBSElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFYd0J3QUdnQWJ3QnVBR1VBYmdC?=
 =?us-ascii?Q?MUFHMEFZZ0JsQUhJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJqQUhV?=
 =?us-ascii?Q?QWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QVpBQmhBSE1BYUFCZkFIWUFNQUF5?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?TUFkUUJ6QUhRQWJ3QnRBRjhBY3dCekFHNEFYd0JyQUdVQWVRQjNBRzhBY2dC?=
 =?us-ascii?Q?a0FITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWXdCMUFITUFkQUJ2QUcw?=
 =?us-ascii?Q?QVh3QnpBSE1BYmdCZkFHNEFid0JrQUdVQWJBQnBBRzBBYVFCMEFHVUFjZ0Jm?=
 =?us-ascii?Q?QUhZQU1BQXlBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFB?=
 =?us-ascii?Q?QUFBSUFBQUFBQUo0QUFBQmpBSFVBY3dCMEFHOEFiUUJmQUhNQWN3QnVBRjhB?=
 =?us-ascii?Q?Y3dCd0FHRUFZd0JsQUY4QWRnQXdBRElBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FB?=
 =?us-ascii?Q?QUdRQWJBQndBRjhBY3dCckFIa0FjQUJsQUY4QVl3Qm9BR0VBZEFCZkFHMEFa?=
 =?us-ascii?Q?UUJ6QUhNQVlRQm5BR1VBWHdCMkFEQUFNZ0FBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFaQUJzQUhBQVh3QnpB?=
 =?us-ascii?Q?R3dBWVFCakFHc0FYd0JqQUdnQVlRQjBBRjhBYlFCbEFITUFjd0JoQUdjQVpR?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCa0FHd0FjQUJm?=
 =?us-ascii?Q?QUhRQVpRQmhBRzBBY3dCZkFHOEFiZ0JsQUdRQWNnQnBBSFlBWlFCZkFHWUFh?=
 =?us-ascii?Q?UUJzQUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1VBYlFCaEFHa0FiQUJmQUdFQVpBQmtB?=
 =?us-ascii?Q?SElBWlFCekFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFB?=
 =?us-ascii?Q?QUNlQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhBQWNnQnZBR29BWlFCakFI?=
 =?us-ascii?Q?UUFYd0JqQUc4QVpBQmxBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ0QUdFQWNn?=
 =?us-ascii?Q?QjJBR1VBYkFCc0FGOEFkQUJsQUhJQWJRQnBBRzRBZFFCekFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBIi8+PC9tZXRhPg=3D=3D?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR18MB5220:EE_|MW3PR18MB3658:EE_
x-ms-office365-filtering-correlation-id: ac9832de-a88f-421c-a17a-08db08fd475b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eDA6BmXZAI4gfuUgHTit5YknQSbPKUvDX77k9I/mkSyrzkSlIl7XgOowwlXD0rnzqTeYtrLShQhPShkzl4UteTQrKBUvmqzg3UFEWQBNJCUhK/pCad+Sd8PVDG2vPAlbaogYW3npwcJ4irRYTjWnkMYsVjS7JRu3Ha6jTYozvMfg2/gP48TQNC6JXXCclhRYg9Lg7sITaV6G2z1sxDO8ItZYEzvVIQ9GaofX23851IMLKOYaVBpooINVKLb/7H9uyBS7kyjiWDy0jV/CmSYFM9tCtVLs08zH/maQX3eMzrfdaOvSFx24QTdA1nXV/5spcnvVSrxytBxH1OmqQGUGaMKg7sMsW0/4DSOAShNDCzOO3mgbzS7e8IrQC1Ac4nvSdzsJPZTjL+nDO2FOaYylkXGxs7VYmRBNCFY9aq0/Jehq266VhYsRmYWSB+loBVA+5QMVyfWAq1SQKDCKRwDoRlV2S+T/B7KxtZ5xOI6akgKUDet59L7ncta9mcmLlGbT3pg3R3LdVY7fJAFl8wwnkm4+bRzJYm7hjeczcuV0PyrErTCQYuW2vLMLYP3OtUhjXn16WUyVGghSZBzqTVAdudqM7cK+ppXdFOmCgXILlVpJlLXIcBJ3ZnmM4pUuYs8XYc+U437m1kESwjGnwnNip3//X3bEpvIEYKazy0K+KaBUlcMhJ5gXfPFZlEMad+cHfDo1aI15UfuNcylFJPEmqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR18MB5220.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(376002)(136003)(366004)(451199018)(52536014)(5660300002)(33656002)(2906002)(38070700005)(41300700001)(8936002)(86362001)(316002)(9686003)(66556008)(186003)(54906003)(38100700002)(6916009)(66476007)(66446008)(64756008)(66946007)(478600001)(8676002)(122000001)(55016003)(76116006)(4326008)(107886003)(26005)(83380400001)(7696005)(6506007)(71200400001)(66899018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JjtaXd+MldEyab1smT1enQFINgaQw175avZSqi87XHPL5D94lV3ZP96zH2fk?=
 =?us-ascii?Q?c4ekRMCScXGdh3i4J2fvW62jjaGDZ3Op51/LfY0hnXW+3Nl0382DbtJW4iEm?=
 =?us-ascii?Q?RuX4JRXjKz3nbloDPNDt+ewTYRavjtayTPC47KebFKFl9hJ6+ffr3aguCluX?=
 =?us-ascii?Q?af11eJZZZYCwH2RNO4FQxGxT95w0KbcYeFRnOVL0+9lWsgDSMPaMI/EAVou8?=
 =?us-ascii?Q?HjD5FHy0y4vgkMev09jptmObJhK7eW374JWdlkfrfgb1hY/fM0adbMjb1jwI?=
 =?us-ascii?Q?+3H4nVrk8UtbNGrUezdZwigscITtID6sKgG9va5D2rqc3k9oxxyOsJoMwaPl?=
 =?us-ascii?Q?QaAakV47h//2fWO6HK7YK+8lKFdmv2/yisFKUSaM8VfmRn3DVLi05uwB/P8W?=
 =?us-ascii?Q?3BMr/xdUEm+M9ObWAiAUyHE0z8UQpvx81QAtkTLgVfkgGkIxwx+2cQ69myC0?=
 =?us-ascii?Q?aNiaYHWNk5nQUkk/wetPTMMjblqNRuBHsFrCDouvH3B/+Qf2Lg7io0VSBP83?=
 =?us-ascii?Q?SiyP1jXMaSM2Ataz0rkY375Vf6Byz1mqBHAL0V1rjY4JHf+HhOVnOSaFmZTJ?=
 =?us-ascii?Q?+BOKAQ+FfXSbsY2vIRpuau4VDnw+KK2dTu9FEt5P9IzeAiNRWrnMCmsPogzw?=
 =?us-ascii?Q?zImqfJxCb+7DvPJiZoQCqCStBQ6vffB/2EmolappJbOXMd6oqUX7HEalfMj2?=
 =?us-ascii?Q?ySeM7ytNyLV6UNiGkJtwXfSjfo61w8JyCpTu8aK46LD5nvBDMqtjMVqe9Z0w?=
 =?us-ascii?Q?JnEBy+9wDXNHAZ4NvqRZzKWJdNBwIhOyIJD8VZAjjfS9KsKortULhutVI1OY?=
 =?us-ascii?Q?HREVqqz2Fx0hFamD4298Ql3YbXFxz7Y4yLPKGICIfVCYIpDH8ehxdybg7bTC?=
 =?us-ascii?Q?l5A0vGW62h+kr51U+IoddOUUJ+SZWGFO5xq+KdM8AXqCQ9oJgMr0fahoTscV?=
 =?us-ascii?Q?T6P8cqeqx72sEyzr+rXxokMAfHZ2ct2BLoqPGQ5JPfvQ2Gm17NWnEwftqE1e?=
 =?us-ascii?Q?ssOZcpiFreYNmYXmRrwKBKq2uf5FtAaPFlkdqc6KvOB6nwJzFmzR3He5vRPF?=
 =?us-ascii?Q?Tk+chlaonZZT+SQ4sV7cO2dyk3bGCse61A19CfSfMeXTdlyKW607hL+EDxmj?=
 =?us-ascii?Q?UljaGQuIhguDWm+CDpVVrd3Q2bL/P+vFvwTO7AUoFJ6Da/7si2BfaO4oJqo+?=
 =?us-ascii?Q?OWCqaeUpOXZucBJwSLzwLTklWr3h/8lFPDXepfGvVee9Caf2zVaChUsQuGhN?=
 =?us-ascii?Q?aa+muzQNPZl2tDXyEl6VBLbaAl7RIi3M0WXBswRq/rGhCEB8wVQB26+LZP1A?=
 =?us-ascii?Q?v+dg5vdLBJ4vSOAzvP2QL/4UTbmOvzfIuagRRjqD7B3mEk4jdZx1uxY/kI0v?=
 =?us-ascii?Q?rFdR5zotL2n10vNcBFU1wssGb7p6/rE5BUOtIoMUeZX0uWD2gsnhyFMB0S7Y?=
 =?us-ascii?Q?RpL7Rrk1HEGh4xer7YaLFQqjeUim+FEPExCZEKLFjNrt7T0C1doymW3ulXVX?=
 =?us-ascii?Q?RXbPnoZ4tP7KddSFxjjiKI1d9q8Fuf1+/VwkpljsbsuUeWaEXeW32hSeQYD+?=
 =?us-ascii?Q?QfFO5jlvF6U4P1HJkiRsGFUy8FVB2rHGdC4HAy14?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR18MB5220.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac9832de-a88f-421c-a17a-08db08fd475b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 11:20:11.9680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4kR9fNZOM8469jV/M1mchhYHxVLk6w4JgLcZBHwjX8yCkYxT9WrDmpTSTnhK3RZLtukn+iHt2cB26dyz4c7Ocw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3658
X-Proofpoint-GUID: zk9XXJ-GDJNoakMZXhErC4e81yRtys1_
X-Proofpoint-ORIG-GUID: 2-FPFnLyx4fcXwWz2aae6esP6Bq8P_qc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-07_03,2023-02-06_03,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,
We have observed IO failure on 3PAR array that supports DIF/DIX with upstre=
am code. An error is only seen when IOs are done on DM devices, no error ob=
served if IO is done on /dev/sdX.
I added some prints to understand the problem and figured out that SCSI_PRO=
T_IP_CHECKSUM flag is not set in scmnd->prot_flags. Ideally it should be se=
t as BIP_IP_CHECKSUM should be set.

--------------------<START: IO to /dev/sdc>----------------
[Mon Feb 6 17:54:56 2023] SK: bio_integrity_prep setting IP_CHECKSUM bio=3D=
ffff976f8d19c300 bip_flags=3D0x11
[Mon Feb 6 17:54:56 2023] SK: sd_setup_protect_cmnd setting IP_CHECKSUM bio=
=3Dffff976f8d19c300 bip_flags=3D0x11
[Mon Feb 6 17:54:56 2023] SK: bio_integrity_prep setting IP_CHECKSUM bio=3D=
ffff976f8d19c300 bip_flags=3D0x11
[Mon Feb 6 17:54:56 2023] SK: sd_setup_protect_cmnd setting IP_CHECKSUM bio=
=3Dffff976f8d19c300 bip_flags=3D0x11
-------------------<END: IO to /dev/sdc>-----------------

----------------<START: IO to dm-10>---------------------
[Mon Feb 6 17:55:13 2023] SK: bio_integrity_prep setting IP_CHECKSUM bio=3D=
ffff976f8d19c300 bip_flags=3D0x11
[Mon Feb 6 17:55:13 2023] SK: sd_setup_protect_cmnd else IP_CHECKSUM bio=3D=
ffff976fa15fa490 bip_flags=3D0x0
[Mon Feb 6 17:55:13 2023] dm-10: guard tag error at sector 0 (rcvd 0000, wa=
nt ffff)
[Mon Feb 6 17:55:13 2023] SK: bio_integrity_prep setting IP_CHECKSUM bio=3D=
ffff978f0752c180 bip_flags=3D0x11
[Mon Feb 6 17:55:13 2023] SK: sd_setup_protect_cmnd else IP_CHECKSUM bio=3D=
ffff976fc87fef10 bip_flags=3D0x0
[Mon Feb 6 17:55:13 2023] dm-10: guard tag error at sector 0 (rcvd 0000, wa=
nt ffff)
[Mon Feb 6 17:55:13 2023] Buffer I/O error on dev dm-10, logical block 0, a=
sync page read
-----------------<END: IO to dm-10>------------------------

Its noticed that bio pointer get changed when IO is done through dm device.=
  I added more debug prints in bio_clone and bio_integrity_clone and conclu=
ded that bip_flags are not getting copied in bio_integrity_clone routine.

--------------------
[Tue Feb  7 14:15:47 2023] SK: bio_integrity_prep setting IP_CHECKSUM bio=
=3Dffff891ecc5fa840 bip_flags=3D0x11
[Tue Feb  7 14:15:47 2023] SK: __bio_clone: bio=3Dffff891ed97b5990 bio_src=
=3Dffff891ecc5fa840
[Tue Feb  7 14:15:47 2023] SK: bio_integrity_clone: bip=3Dffff891ecc5fd500 =
bip_src=3Dffff891ecc5fcb40 bip_flags=3D0x0 src_bip_flags=3D0x11
[Tue Feb  7 14:15:47 2023] SK: sd_setup_protect_cmnd else IP_CHECKSUM bio=
=3Dffff891ed97b5990 bip_flags=3D0x0
[Tue Feb  7 14:15:47 2023] dm-3: guard tag error at sector 0 (rcvd 0000, wa=
nt ffff)
[Tue Feb  7 14:15:47 2023] Buffer I/O error on dev dm-3, logical block 0, a=
sync page read
----------------------------------

If I add the change to copy the flags, following  BUG_ON in slub.c is repor=
ted
------------------<code>-------------
diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 3f5685c00e36..07e7443c7be3 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -418,6 +418,7 @@ int bio_integrity_clone(struct bio *bio, struct bio *bi=
o_src,

        bip->bip_vcnt =3D bip_src->bip_vcnt;
        bip->bip_iter =3D bip_src->bip_iter;
+       bip->bip_flags =3D bip_src->bip_flags;

        return 0;
 }
----------------<code>---------------

------------------<BUG_ON>--------------
[  751.838432] kernel BUG at mm/slub.c:435!
[  751.838440] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[  751.838443] CPU: 49 PID: 981 Comm: kworker/49:1H Kdump: loaded Not taint=
ed 6.2.0-rc1+ #14
[  751.838447] Hardware name: Dell Inc. PowerEdge R7525/0590KW, BIOS 2.5.6 =
10/06/2021
[  751.838448] Workqueue: kintegrityd bio_integrity_verify_fn
[  751.838458] RIP: 0010:__slab_free+0x1ae/0x300
[  751.838467] Code: 4c 89 e6 48 89 ef 5d 41 5c 41 5d 41 5e 41 5f e9 d8 fb =
ff ff 48 83 c4 60 4c 89 f7 5b 5d 41 5c 41 5d 41 5e 41 5f e9 62 3b 00 00 <0f=
> 0b 80 4c 24 4b 80 e9 ea fe ff ff 4c 89 fa 4d 89 d7 4c 8b 54 24
[  751.838469] RSP: 0018:ffffbb674fcf7dd0 EFLAGS: 00010246
[  751.838472] RAX: ffff9c320d3546e0 RBX: ffff9c325302e480 RCX: 00000000804=
0003f
[  751.838473] RDX: ffffffc10e1546c0 RSI: ffffdfb30434d500 RDI: ffff9c32000=
42500
[  751.838475] RBP: ffff9c3200042500 R08: 0000000000000001 R09: ffffffffb4f=
bf08a
[  751.838476] R10: ffffbb674fcf7ca0 R11: ffffffffb65e4ac8 R12: ffffdfb3043=
4d500
[  751.838477] R13: ffff9c320d3546c0 R14: ffff9c320d3546c0 R15: ffff9c320d3=
546c0
[  751.838479] FS:  0000000000000000(0000) GS:ffff9c70ff840000(0000) knlGS:=
0000000000000000
[  751.838481] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  751.838482] CR2: 00007fe84efedb00 CR3: 000000015472a000 CR4: 00000000003=
50ee0
[  751.838484] Call Trace:
[  751.838485]  <TASK>
[  751.838487]  ? bio_integrity_process+0x14f/0x1c0
[  751.838494]  ? __pfx_t10_pi_type1_verify_ip+0x10/0x10 [t10_pi]
[  751.838501]  bio_integrity_free+0xaa/0xb0
[  751.838504]  bio_integrity_verify_fn+0x40/0x50
[  751.838507]  process_one_work+0x1e5/0x3b0
[  751.838513]  ? __pfx_worker_thread+0x10/0x10
[  751.838515]  worker_thread+0x50/0x3a0
[  751.838518]  ? __pfx_worker_thread+0x10/0x10
[  751.838520]  kthread+0xd9/0x100
[  751.838525]  ? __pfx_kthread+0x10/0x10
[  751.838528]  ret_from_fork+0x2c/0x50
[  751.838535]  </TASK>
----------------------<BUG_ON>---------------

Queries
1) Is there a specific reason for not copying the bip_flags in bio_integrit=
y_clone function?
2) If bip_flags needs to be copied then is there something else needs to be=
 done that will take care of BUG_ON?
3) if not, then what should be right solution for fix an IO error because o=
f SCSI_PROT_IP_CHECKSUM flag not set.


Thanks,
~Saurav=20

