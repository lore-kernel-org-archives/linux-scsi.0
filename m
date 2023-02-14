Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF7FAC61DA4
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Feb 2023 06:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbjBNG64 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Feb 2023 01:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbjBNG6z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2023 01:58:55 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA3B1DBAE
        for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2023 22:58:53 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31E6Rl6c010313
        for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2023 22:58:52 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3nr516g2ha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2023 22:58:52 -0800
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31E6o8Ol000789
        for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2023 22:58:52 -0800
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3nr516g2h7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 22:58:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hvxD+M2xB3FRRUAjm0vXKB9F4XVpMQvjALg7R2UCBR+C2VC1rsy6lTckIiccDgiHe10SP/exAw0PKOjNhidQzSAG6dpVbOaZNqRtW8vZ0fwCUhvhKXoyhKVJaAKb58pLpRLOvCDRECjPovIUezLdPl6GmNr2SOse3KrkxyZ2lcrrK3XVJsQawqnXEFVcj+ayEA0ECkp0l72Szjs3S5oV5iyEL5jMtEP0ovC21cHgYAxDHVR1Ut3uWFbqHOcndIuL4qtgU6+IDeGXnF/4I8wEaFrhiCjsEtj9GujPttNuMJsw4UC0LlHYxunsOAZbFWASYLed6gJz6C06W/7dfY3Qsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O2W/L28g6UVTxm5Pm2tfp/Ymt1+SjRex61uEnvmhXNg=;
 b=jvUISLXj3jAJR4j2w/cUs1VvoleOfXtVRyOWKGux2qGwsaUd8RkGV4GlnM9YsK8HsrkSuYZpCnAFMZWPFr+gbzVW2kLMYo8Y/dAgF0E/j9ilTk333499gmn/ZaIbCGDefciozhC9XvgrvIVGsIPB/gbkUr4SJBrsVX8A8KxXCvYdk6YpqXFPccUGGkq2yNOL4XJG/qlTyeP/kTtaA8yWWVx/XDWjhyFAN7wdRwwm3vw7Px3Mh3vi/W/yP6+dUm2BO8uoas40PZAS7YP3b7OGCnlUEscSXyb22IQ0YGeioh9MY6twQPRXcWumkNBtAiec4ioS96NtZ7l0pq3MdrOz5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O2W/L28g6UVTxm5Pm2tfp/Ymt1+SjRex61uEnvmhXNg=;
 b=OGJeKKOHK84ymmySmYxdpeBrJ121WHUhcIA8PFKF6bK/n+Bhl15uvAMKTBq5n6LNXFHyPjrxlYdDQcH5pRa2/ZDF6DNgu4q3pKasn/JdRbluVUxre9m4mbnOVAmZdr8Z2DR3wKLpqX43WwdEJRuIRGRRuWNVv+qH1MJhP4jK3M8=
Received: from DM4PR18MB5220.namprd18.prod.outlook.com (2603:10b6:8:53::16) by
 SN7PR18MB3840.namprd18.prod.outlook.com (2603:10b6:806:104::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24; Tue, 14 Feb 2023 06:58:48 +0000
Received: from DM4PR18MB5220.namprd18.prod.outlook.com
 ([fe80::bbcc:7359:7a4d:3e3b]) by DM4PR18MB5220.namprd18.prod.outlook.com
 ([fe80::bbcc:7359:7a4d:3e3b%8]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 06:58:44 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Girish Basrur <gbasrur@marvell.com>
Subject: RE: IO error on DIF/DIX supported array
Thread-Topic: IO error on DIF/DIX supported array
Thread-Index: Adk65h58aAJPomO/QEKOGTaF0/rqJAFW57Ng
Date:   Tue, 14 Feb 2023 06:58:44 +0000
Message-ID: <DM4PR18MB5220EFBF8D8036A9446DD796D2A29@DM4PR18MB5220.namprd18.prod.outlook.com>
References: <DM4PR18MB5220E0AF6564DF1A1F126EF0D2DB9@DM4PR18MB5220.namprd18.prod.outlook.com>
In-Reply-To: <DM4PR18MB5220E0AF6564DF1A1F126EF0D2DB9@DM4PR18MB5220.namprd18.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2thc2h5YXBc?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy0wM2I5YTkyNC1hYzM1LTExZWQtOTUxNi00ODJh?=
 =?us-ascii?Q?ZTM1NzAzZTVcYW1lLXRlc3RcMDNiOWE5MjYtYWMzNS0xMWVkLTk1MTYtNDgy?=
 =?us-ascii?Q?YWUzNTcwM2U1Ym9keS50eHQiIHN6PSI2Mjg5IiB0PSIxMzMyMDgzMTUyMjQx?=
 =?us-ascii?Q?ODgwMjgiIGg9IkY2cWJzMjJndGdaWCtZMG8xaEtrcUhRMEZwST0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUhZSUFB?=
 =?us-ascii?Q?Qjg1QkRHUVVEWkFiUWhIRWVYSlFJYXRDRWNSNWNsQWhvTkFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQUFHQ0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRQUJBQUFBMUZIM2FBQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFa?=
 =?us-ascii?Q?QUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4QWNB?=
 =?us-ascii?Q?QmxBSElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQXdBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFB?=
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
x-ms-traffictypediagnostic: DM4PR18MB5220:EE_|SN7PR18MB3840:EE_
x-ms-office365-filtering-correlation-id: 4c98888e-3550-4f13-57f4-08db0e58e9d7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FU72/gvqp1f+rtRJBRzCJcGLHS+Xi8/IwKqVMxrAESXqPdzOn1gV+TVeNu8glsDIKiZ53jfcWqRvT4jRslXzE6VQKYe2khB76zcn9MdCkF/Ke6/mg5fYrSpLD6q08+AIY6Yczen4dlkKwJXz7l2X46NP5fRXZO3wRVoCUwWWs7NosNc3mNsUN00X8p5t0b9Tb2V6vN5tiX5Cg8WBL/U8avOkOEZRwNLzyHsP5BwjadfZrz7GLcNtxYMFu9lMIgo30xCAs0hvakGVIzowaqoTw8yQjLcmshSFmViFv14xFGyc7UVxsbmjZ6Xqa2J0BbvWhunMsQI+jlsQPcnWdA+eHB2QABEuRjVCRwxBk0C0Qwwjdz6ZyX72pTi+GQv+NuoRu7SVYp5DJtW2uP9oqailm1Jj2maMinCCvV8GMn8Sap3pDP+N12W9imMZMxQ2i4u+2bwhlrgWmb+q39oYz5MQKUB6C9cO5PktmwQ9wasDNayvj1jOQ9H9MIbtgrHORsFsRU+7afAYPXBiTjZ92Z5EY0Xpc2vSM9AwUvEAVuXM0HDTFu/OtcxLxT98c3psotlXDSDGlm8FPmMRWFmCNrIVa1FLrtS81VckWDLzznyMnVMIfDroYlDhV9e51jBM5qrYvWRlYzqdVoz6un1Hv6xPhFZxMyGPboDm4gmQgKDj+jpUGXKc+DrF3MsjxU6Cx8pUXbeEzuMGd+YCcllwxiIleA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR18MB5220.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(451199018)(52536014)(2906002)(5660300002)(8936002)(41300700001)(66899018)(66946007)(4326008)(66556008)(66446008)(66476007)(64756008)(76116006)(6916009)(8676002)(55016003)(316002)(53546011)(6506007)(54906003)(478600001)(9686003)(107886003)(71200400001)(186003)(83380400001)(38100700002)(122000001)(86362001)(33656002)(7696005)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1OQCj52rLIXCaGNLF7baHOOrbV8Xw1y1YICFgqq4WKDhse2zjU6ooEzW1RIB?=
 =?us-ascii?Q?GfCj+QOsUaYkq8ZLTqVhUnc7ZRi8FkLiE+jNYQYeE7BZ5trx84vJP7D9/fYF?=
 =?us-ascii?Q?RzNfkJdGATU1CplMdDAv/yfEgxDFRwkqQBKHSXQedGmVKc0xzKZMSM+qikct?=
 =?us-ascii?Q?1WfRtUnU02J9FuglM8O0QaEQHWYsRjoyy/SPowtV+LjUp2I9upj1tNUTMpAe?=
 =?us-ascii?Q?iQdut4kmoRMQDBnKaNiE8+QSrbh1q1ZvdYMyo5ydX983ZCxvFWtkP3EJzzTI?=
 =?us-ascii?Q?aGBnPSadr7dgZ1DU/71wSkIWDdgdJRYA2bCNUJa3+CoZPfTuxwImrF6g/QbU?=
 =?us-ascii?Q?hChqYsi1MOWHOMID8bb5fUNRuMiIVSXWFFHVxgfGCfkNyKwoz2JKmTJGZjpM?=
 =?us-ascii?Q?SYYaa1mIcQidhD4WAxvIBln70cNc5sedQQH3xOmu6Q8/Bm2D3Xbv2S0YkMm3?=
 =?us-ascii?Q?vZGIsZiu8QZZTMTe4qYPcWf1B3+XGqK5N7v8LUvvGdZ4twAhUql3HKQIkn7R?=
 =?us-ascii?Q?uaC4XceWmZ5kjAPW5Vy+r/cBmI+raRE2ahxdZXyPOpODeV+I24x15/G2xKkj?=
 =?us-ascii?Q?p1S6qzdXRZYnPyTjN6dpvVFv6XgemXB392kFMVfOVJd6oZxqiRN/jNCYp4fJ?=
 =?us-ascii?Q?2eL/wg4zZR/cAEC4bXExo1Fqa0cK/3i2JnY+5ZZ/ktMW7eGzdc639jqRAoBf?=
 =?us-ascii?Q?V8KTuqqsPkhMPwvztEXhgpkFXg0j69z2wjzH1T4xhnyD+1yHWzKQxYxiV0Rb?=
 =?us-ascii?Q?K0mXYy0LmNUNkvnoflQbMvec8J+G6+6oppXiM0dY4E5BrhYV3Tdsku7n4LjQ?=
 =?us-ascii?Q?pXsAOh4ADlKvdYvjGXHFbUGPl62RlszWYzMTyr0h92yQMwCQCdjUUReq6oOg?=
 =?us-ascii?Q?W+UhEXpL6MdIVFqDdrC0Zsy837a/F4L+nVYMQCaqIdv+bwzqIIMi/OH1JidS?=
 =?us-ascii?Q?ab6B7g4QfNooDIj5qUMsnCKCDqAemOukFbJ0FDXAUFPlbruiTNhjPHkOfjpC?=
 =?us-ascii?Q?o64r3sLd2qkWcSJURSncTM1KJj8p8tDTIWZFNYNnLRN1+EygSbKzKWMbtj15?=
 =?us-ascii?Q?tmamCg26Ez1btwXtlF25IRI+DvpEsafT7PbEkAxWgsXpS15LxBEs+R/0Wews?=
 =?us-ascii?Q?zJbIrnlhGqWOk5vGaRAtuyooC3GTP/H5mG7ByMm0HX0HKqwHaVYy/1HytMKw?=
 =?us-ascii?Q?V7sgJq1k5TX4ONUyQW6/wFTHqNjlmWRkWXFtYCUOzPkXYnVgK/vdQCDDLDLC?=
 =?us-ascii?Q?BBIOKB3ONrTEwQE278NXSsctUsAyGm7J6kdBEBSp7XeGxLKkvhDJVJ4bKxO8?=
 =?us-ascii?Q?m7udD7UOp2dMv+PJwY40L1zh2MBrOFidhoqgcwTTgkTtb7MVEY65GXyuxQYx?=
 =?us-ascii?Q?gWiKD+ZDiItL4HR2R74j8RfZYBqrFgL3k4IbhiwTuq1fG3mPDiMm4bj0Xdow?=
 =?us-ascii?Q?3kmOClkh9ddEe2Fn3KyQ77NA5fUR5G9kMBiZWdcLYb8f7ex3OrFszYO7O0c9?=
 =?us-ascii?Q?nLrEpPE5P7+ShCMEiYi5XHFz8DXfQkNFAAcL+DVEVtNoE2UHZO+Mqv4bJUTM?=
 =?us-ascii?Q?8RQLXOfKQLFXLIth/qQhiCEqmK3tO1MV31NUpxB3W/L5RciIrv6kb8SwDJxs?=
 =?us-ascii?Q?Vt7DdTY1o1gmVWTeW3eZXCxk0pi93K1jjSXEGm1KvERQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR18MB5220.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c98888e-3550-4f13-57f4-08db0e58e9d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 06:58:44.5703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jjKdcVFB0zalsz6uc5FWD7HfYa5B1M2tVJ9BclMYCLV1WD+Plj2QYXx+s++pltF+WYW0RuWK5qKk5GkRhtjjoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR18MB3840
X-Proofpoint-ORIG-GUID: 7CUH0U4LijbeYFTfGOw3N2Uc6ErXHDyD
X-Proofpoint-GUID: 6y4iojdZ1ZZhXOGIEOID6tRI9w860v_A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-14_04,2023-02-13_01,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,
Any inputs on this one?

Thanks,
~Saurav

> -----Original Message-----
> From: Saurav Kashyap
> Sent: Tuesday, February 7, 2023 4:50 PM
> To: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: linux-scsi <linux-scsi@vger.kernel.org>; Girish Basrur
> <gbasrur@marvell.com>
> Subject: IO error on DIF/DIX supported array
>=20
> Hi Martin,
> We have observed IO failure on 3PAR array that supports DIF/DIX with
> upstream code. An error is only seen when IOs are done on DM devices, no
> error observed if IO is done on /dev/sdX.
> I added some prints to understand the problem and figured out that
> SCSI_PROT_IP_CHECKSUM flag is not set in scmnd->prot_flags. Ideally it
> should be set as BIP_IP_CHECKSUM should be set.
>=20
> --------------------<START: IO to /dev/sdc>----------------
> [Mon Feb 6 17:54:56 2023] SK: bio_integrity_prep setting IP_CHECKSUM
> bio=3Dffff976f8d19c300 bip_flags=3D0x11
> [Mon Feb 6 17:54:56 2023] SK: sd_setup_protect_cmnd setting
> IP_CHECKSUM bio=3Dffff976f8d19c300 bip_flags=3D0x11
> [Mon Feb 6 17:54:56 2023] SK: bio_integrity_prep setting IP_CHECKSUM
> bio=3Dffff976f8d19c300 bip_flags=3D0x11
> [Mon Feb 6 17:54:56 2023] SK: sd_setup_protect_cmnd setting
> IP_CHECKSUM bio=3Dffff976f8d19c300 bip_flags=3D0x11
> -------------------<END: IO to /dev/sdc>-----------------
>=20
> ----------------<START: IO to dm-10>---------------------
> [Mon Feb 6 17:55:13 2023] SK: bio_integrity_prep setting IP_CHECKSUM
> bio=3Dffff976f8d19c300 bip_flags=3D0x11
> [Mon Feb 6 17:55:13 2023] SK: sd_setup_protect_cmnd else IP_CHECKSUM
> bio=3Dffff976fa15fa490 bip_flags=3D0x0
> [Mon Feb 6 17:55:13 2023] dm-10: guard tag error at sector 0 (rcvd 0000, =
want
> ffff)
> [Mon Feb 6 17:55:13 2023] SK: bio_integrity_prep setting IP_CHECKSUM
> bio=3Dffff978f0752c180 bip_flags=3D0x11
> [Mon Feb 6 17:55:13 2023] SK: sd_setup_protect_cmnd else IP_CHECKSUM
> bio=3Dffff976fc87fef10 bip_flags=3D0x0
> [Mon Feb 6 17:55:13 2023] dm-10: guard tag error at sector 0 (rcvd 0000, =
want
> ffff)
> [Mon Feb 6 17:55:13 2023] Buffer I/O error on dev dm-10, logical block 0,
> async page read
> -----------------<END: IO to dm-10>------------------------
>=20
> Its noticed that bio pointer get changed when IO is done through dm devic=
e.
> I added more debug prints in bio_clone and bio_integrity_clone and
> concluded that bip_flags are not getting copied in bio_integrity_clone
> routine.
>=20
> --------------------
> [Tue Feb  7 14:15:47 2023] SK: bio_integrity_prep setting IP_CHECKSUM
> bio=3Dffff891ecc5fa840 bip_flags=3D0x11
> [Tue Feb  7 14:15:47 2023] SK: __bio_clone: bio=3Dffff891ed97b5990
> bio_src=3Dffff891ecc5fa840
> [Tue Feb  7 14:15:47 2023] SK: bio_integrity_clone: bip=3Dffff891ecc5fd50=
0
> bip_src=3Dffff891ecc5fcb40 bip_flags=3D0x0 src_bip_flags=3D0x11
> [Tue Feb  7 14:15:47 2023] SK: sd_setup_protect_cmnd else IP_CHECKSUM
> bio=3Dffff891ed97b5990 bip_flags=3D0x0
> [Tue Feb  7 14:15:47 2023] dm-3: guard tag error at sector 0 (rcvd 0000, =
want
> ffff)
> [Tue Feb  7 14:15:47 2023] Buffer I/O error on dev dm-3, logical block 0,=
 async
> page read
> ----------------------------------
>=20
> If I add the change to copy the flags, following  BUG_ON in slub.c is rep=
orted
> ------------------<code>-------------
> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index 3f5685c00e36..07e7443c7be3 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -418,6 +418,7 @@ int bio_integrity_clone(struct bio *bio, struct bio
> *bio_src,
>=20
>         bip->bip_vcnt =3D bip_src->bip_vcnt;
>         bip->bip_iter =3D bip_src->bip_iter;
> +       bip->bip_flags =3D bip_src->bip_flags;
>=20
>         return 0;
>  }
> ----------------<code>---------------
>=20
> ------------------<BUG_ON>--------------
> [  751.838432] kernel BUG at mm/slub.c:435!
> [  751.838440] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> [  751.838443] CPU: 49 PID: 981 Comm: kworker/49:1H Kdump: loaded Not
> tainted 6.2.0-rc1+ #14
> [  751.838447] Hardware name: Dell Inc. PowerEdge R7525/0590KW, BIOS
> 2.5.6 10/06/2021
> [  751.838448] Workqueue: kintegrityd bio_integrity_verify_fn
> [  751.838458] RIP: 0010:__slab_free+0x1ae/0x300
> [  751.838467] Code: 4c 89 e6 48 89 ef 5d 41 5c 41 5d 41 5e 41 5f e9 d8 f=
b ff ff
> 48 83 c4 60 4c 89 f7 5b 5d 41 5c 41 5d 41 5e 41 5f e9 62 3b 00 00 <0f> 0b=
 80 4c 24
> 4b 80 e9 ea fe ff ff 4c 89 fa 4d 89 d7 4c 8b 54 24
> [  751.838469] RSP: 0018:ffffbb674fcf7dd0 EFLAGS: 00010246
> [  751.838472] RAX: ffff9c320d3546e0 RBX: ffff9c325302e480 RCX:
> 000000008040003f
> [  751.838473] RDX: ffffffc10e1546c0 RSI: ffffdfb30434d500 RDI:
> ffff9c3200042500
> [  751.838475] RBP: ffff9c3200042500 R08: 0000000000000001 R09:
> ffffffffb4fbf08a
> [  751.838476] R10: ffffbb674fcf7ca0 R11: ffffffffb65e4ac8 R12:
> ffffdfb30434d500
> [  751.838477] R13: ffff9c320d3546c0 R14: ffff9c320d3546c0 R15:
> ffff9c320d3546c0
> [  751.838479] FS:  0000000000000000(0000) GS:ffff9c70ff840000(0000)
> knlGS:0000000000000000
> [  751.838481] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  751.838482] CR2: 00007fe84efedb00 CR3: 000000015472a000 CR4:
> 0000000000350ee0
> [  751.838484] Call Trace:
> [  751.838485]  <TASK>
> [  751.838487]  ? bio_integrity_process+0x14f/0x1c0
> [  751.838494]  ? __pfx_t10_pi_type1_verify_ip+0x10/0x10 [t10_pi]
> [  751.838501]  bio_integrity_free+0xaa/0xb0
> [  751.838504]  bio_integrity_verify_fn+0x40/0x50
> [  751.838507]  process_one_work+0x1e5/0x3b0
> [  751.838513]  ? __pfx_worker_thread+0x10/0x10
> [  751.838515]  worker_thread+0x50/0x3a0
> [  751.838518]  ? __pfx_worker_thread+0x10/0x10
> [  751.838520]  kthread+0xd9/0x100
> [  751.838525]  ? __pfx_kthread+0x10/0x10
> [  751.838528]  ret_from_fork+0x2c/0x50
> [  751.838535]  </TASK>
> ----------------------<BUG_ON>---------------
>=20
> Queries
> 1) Is there a specific reason for not copying the bip_flags in
> bio_integrity_clone function?
> 2) If bip_flags needs to be copied then is there something else needs to =
be
> done that will take care of BUG_ON?
> 3) if not, then what should be right solution for fix an IO error because=
 of
> SCSI_PROT_IP_CHECKSUM flag not set.
>=20
>=20
> Thanks,
> ~Saurav

