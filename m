Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59649C636D6
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Feb 2023 16:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbjBCQuR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Feb 2023 11:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233412AbjBCQuQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2023 11:50:16 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F811A87BF;
        Fri,  3 Feb 2023 08:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675442991; x=1706978991;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=e2SfmX2CPtKNhq7cHZ4CEAIkhMPPErvJhv4id8FiwgA=;
  b=NK1gvTNTQ72Yvk0wQeZ72uPtLuy60ZqRxIY0+wP9LNCAgQ9wBaQT1WBV
   pIP2VcPHuA2i2QdbQ12fYsjetdqckyx1cboTgG9D3DAthI8uCS7Gu64xo
   vPr7mc/wWfMnlmN9kYmpm1Wj8OPtBzUa62DrBH6c+YiuP5F/TM6IR8T/1
   cQNPmgdIBg22FHjRKNsFcRvS98k+Ejue2rcdztEe07ScxcW9WOL3ABKYZ
   5u8yagWKNJchLqqnX6lZZFrRSTikfkXTe/zqPKVoV7TIBYF3kDSyWBkuQ
   g2aJPraBekqwS3RSdwVenIg5LYCa1DWrVPk6niqURCg/mUadam6WwpA67
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,271,1669046400"; 
   d="scan'208";a="222264981"
Received: from mail-mw2nam10lp2102.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.102])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2023 00:49:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgujtlYo1O+kyspg8iiDBQu6k8+tkjDoTYBiJwKwcgZWvwd2ESaY4ph/xe/SWRNYL5xSE1Q9Pv4mH8ZfBYMQLLFZ2RdhuLeMIj8J7foy8PclWRqqGAOZecfdKGax1oLrZ+yOOBYtLxbWqvIi8JDRAbkEh7WLBkB9hwY29cCBOMZvgeQ7Wx9Z7Zk15rY5TpC9RBEbmUE+8p7iYr3fBkRiCg17WGY4ezBnXxhOAD6xA3ydsjrSItdIS1yiVarmRshHzN0B2ikFNZsXC/VIWS93+ao7FVRIOqfWm7Be4c3BK19oEbK59pJDJ8LrNHNIIscmTOPIHIw+AgUivNf6fPTWmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6gnXPt9fOF+LA/VRy2vifTHlNmwBfsQAqdqY3vuYlJU=;
 b=J37iLSSQt+E7W6OsihrWEeyWJHAKpL1XM0xFlQgGARkypfrh5sO3eOM/z4e1A00nEN8zXWIi6z1eeQIqlHbqxj3m2TY82cVZJAwXT699ABvq5X/Q7uUetQBUevOimQXC2eOG4xWqf6cJ1kef4pEnWtJZulolD49vcIWnbXwpr5pGRsZqIXIqyyb2yVu2/DJTUEPhj9fqi1GBJJjWgnIG4F3efXJ3OzOy6oUdC7cmmfUFVwjIHEtvpRFO1nXBv4/jsACTg0Oeere6ZunWNu/9+1wVXGvSAkuAbV6w3vnJ1Y6GrArem9Z1oDqScuH0ZOHQnxNHAba/ognXUCPh19/+6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6gnXPt9fOF+LA/VRy2vifTHlNmwBfsQAqdqY3vuYlJU=;
 b=OdGFdQf9jxVrBT9uC8bhtjRUGAtNGY+uBntXDe64BVqL13K5hu89zqcCBaiDUd7NQTdE7D2ZygP+OIaBXHbsBqiVSCyVypBSvE1ROaQPXcJQCvp5K0kGjvmpGHYglatyjJN3qvq0vHLkNjSWHzuvjaJoAzHOVWtfOpIseYNTG44=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by PH7PR04MB8506.namprd04.prod.outlook.com (2603:10b6:510:2a4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Fri, 3 Feb
 2023 16:49:24 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a%7]) with mapi id 15.20.6043.023; Fri, 3 Feb 2023
 16:49:23 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Hannes Reinecke <hare@suse.de>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH v3 09/18] scsi: sd: handle read/write CDL timeout failures
Thread-Topic: [PATCH v3 09/18] scsi: sd: handle read/write CDL timeout
 failures
Thread-Index: AQHZMCaaByrk0iicME+j4fEb5fy9+a6yaYeAgAsVGgA=
Date:   Fri, 3 Feb 2023 16:49:23 +0000
Message-ID: <Y907EsIUsbUilZi6@x1-carbon>
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-10-niklas.cassel@wdc.com>
 <f4cca0e6-9c3b-5f0a-c125-fb3960d35e5e@suse.de>
In-Reply-To: <f4cca0e6-9c3b-5f0a-c125-fb3960d35e5e@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|PH7PR04MB8506:EE_
x-ms-office365-filtering-correlation-id: e91a65f5-aa9d-4af8-993f-08db06069a90
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: STj5ymZqOltQZofyDQekv/Zw/I+gujANcxESsi58qvIrSJicbfxH+RjRQIRdQcfaRreRjdWlWYfR3FrIPs5ffsd13yCwnMZKC5ZDJkycLNK+/wTY9U6wyBuzuzX5+kEoesFVSF9DpG5jF0d7WXYi5gjGsfVbPe7mWNarSg1Mp6BmPT300Do5yniDCVU4dAH1cpZj/ENDQpQl2yA+kNox+GjTqZPMCzdbd95h/EKKaS9AQ8hTS/84RlxYgsrRIpultMSS9GkC5dnQ5DQDYNIkShkwiXhoJ23ofHBWVg23nw7SgkzVe9CFtoUBnR0d4hurd21aiJPD6/MebW02THb3sbZGgmqtbuCXHGsrrjtJsKOxuxsdo++Rpo3FgBv/kIYaxkNw9Jg1ivQnHjcOmcJUXeNMw/3j40jKRVrl3p6P6dic2C2pxg2sdNPkKAufDBXb9wSvYra54pLgJ4Trf4e1hNiCO0BqAH5spkTkVNWy7lUmLbwY4N5XxI9+YXhfDZfkSh47/+fADDYB7TkJBUzuyyGPd7yJsODqn7TlyLUtupbdvIm1LPTwAk33nBxUPNYoYSfKb+Z1ZbMT0+SuRlXtNK7mJY2ZACVJe8NsGUDtQNxlgOQ9DzY2WX/+Fi1qXBNIlf6ODXs2gGKxTQdrHdroFkaWidzS0K1ywveu9PQ2ezZ40oivSdLhZfAXAlTneK8SlRiT/NOqhRUdDCiq7iXp5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(451199018)(64756008)(91956017)(66556008)(66946007)(66476007)(66446008)(76116006)(41300700001)(83380400001)(4326008)(66899018)(6916009)(8676002)(316002)(8936002)(9686003)(6512007)(122000001)(54906003)(33716001)(5660300002)(478600001)(71200400001)(2906002)(186003)(86362001)(26005)(38070700005)(6486002)(82960400001)(38100700002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Bn5O+cBSfqBWXWatgwbHq13BPHBeYcRuChh/A7FKUHfMatvpcMsvJz9yx+F1?=
 =?us-ascii?Q?ll/h+Zifke71OMwvQq2Syaea4VbUbkjxvGEDJKPhE1bofI0DO7i6cXNwlZNV?=
 =?us-ascii?Q?lMVm0rMM7XGjWBo2xbWzNz5bqi8aEZ7RFK67OxbxUScxPhyb7tHt5SJ1Upmy?=
 =?us-ascii?Q?947vU9lLDmGsNAYjj1d/hbrt8kIybXjtdBDZp+U0IE34iSjp1aDd9APwMq/M?=
 =?us-ascii?Q?OP/8wv994xJfDQZ3ehY2iFXkPoiUPuCyFyVG8cSrnfXXj4aFm1eKAjwIApPG?=
 =?us-ascii?Q?pOF4+zy8XQ4ilRCAt1IGJeXMZTpCFJhmgE5MGE2MAPT0qN3PVO35mE6E6PeT?=
 =?us-ascii?Q?ivsJ+4onXYPrTUkhqQNkDGGksvwVeXbOb4YC0s8Q/zZdDxuKwftJEfi671jd?=
 =?us-ascii?Q?ACtQfjQ2KnKI9VX7KEwK6OJpbED4gJujRKXgZ+KQov2+aAb6JM9KS8ZteKd1?=
 =?us-ascii?Q?2oeYErWD8pN7+E5W7FCAtKmymIptxUzsu2uY44Hx5sA+xUHft1vTDfzfBIp0?=
 =?us-ascii?Q?ABYXugxRZYmAfkzW+jInmiKIIX2AcBP3LVguHbMxNkr5JvQu0mX4SRIgxPze?=
 =?us-ascii?Q?GRYVJzT1RwgzlztIGm/NY5hozhQINUsSHkN2f5g0+zD8D4nGVj5KiGACzIi1?=
 =?us-ascii?Q?4clZ2KNYOPfVC7tGIJEIxo4amOGrGhiz3MEnr1EQKobxDd85SBLRMJd08Y/q?=
 =?us-ascii?Q?7Kb3mT9uQQ0GritXrWdowssvf3fxbf4POaBA7zeyUbcg9H6Wt/qWPTO/rJ2y?=
 =?us-ascii?Q?LpCLjePCUULWqXpKWrReCWNQbqZpR63se0jI2X0t0NfrJlx/yAygg5Ahj7+e?=
 =?us-ascii?Q?gVsGQNX67gZSPOcN/C/MC9MvSE7UN5QqjzMw/XAR4ZsNhbq+bOTVN01jNfk2?=
 =?us-ascii?Q?UYuIUZY13D1C6saVotx+VPhGEBXFYsTZGkRzdl3fVUsrSNJ9axvhfTrwxFdh?=
 =?us-ascii?Q?/w4iqZbwi60SFb7TrfUuRqH37Txbt8HA/srA2tycsuq6mIur20DAPelarRwR?=
 =?us-ascii?Q?DpyvRFGDEGE60WTK5rETDi8RFgmif0as6cKssh4hL5LTplvgmMKeMIf5LsNK?=
 =?us-ascii?Q?bSYs0DuEh/0a55ORex9gg4qB6EtJFvoqpvdlWKMu63I4WjTX8WdBAOzESNuB?=
 =?us-ascii?Q?S6VnIarPMJW9Bb8v0XQ6D/bu9uiBEoL6x+0fyNU7jI2rgDZrfRIzaXayBMa+?=
 =?us-ascii?Q?2idoU6BG9GCSxYkLLFNOfaTc0B4XQ9VLlIK5icjx1tZIp7HzbXgHSn+vw1we?=
 =?us-ascii?Q?Ksq4Je7p1TCiv/wJsuf4qqKVAFphxPH8/qW+fDjHFKKlLIuuDRzZ59Vor7w3?=
 =?us-ascii?Q?fj/WpHgTWsS4fxwosnmwvogve5XOBxqCGO9+TADlpnicYiJifFo0/sPSKjsi?=
 =?us-ascii?Q?JLEcbVOJ6Yi4PD8oqMnO2UIqsvyb78zcGbFQxmSDjVSfmhEXsk7xJmuajaYD?=
 =?us-ascii?Q?eYnO+Oekv9O6yWAk++L+C951gU40fOIL2fcamv6VI5H5JlrLohZ8t329HGKV?=
 =?us-ascii?Q?HtKEoIJv2YQA2nw7XHy8PILNn6hAcQmU5zzCeg9NI8jJT9FTh+DVV/sYmvKx?=
 =?us-ascii?Q?7+D56Emg1d5Z36gBqin0fY8L56uWH8UGGzWOrVmWu4VKL9ZaiZmqKqz4GNoD?=
 =?us-ascii?Q?Jw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <388DDB4A217FAA489DD15E4AADAE50F1@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: dxq4n5aOXfVl1CE4IbQMD5/ZRVcCsYEUeSPdZJ9qaJbXprf6/+gJW9jJABiIuQ8xFQiFX62PoA8Qy53l0OluTGkb6Jp56GBOzpWFJeBhAgvjMnvaUcV41fxqb87cGWtVqs/zNOK0ya8lKzpVUKBd2lhP7bEN9ZXcEBZOujV9Ho3SJgYLzq7tJyoEVzajZthjaywvRJZWEMkxl/tBAirVqd7ajQLq0DECO82IZ3CYEalkHpNPPIZDUZoHyaqB0u6vdkQ+0yg3v+RssWmXvxMrqet++5n1lURoYUioyrN3JoTWfmBywCIA159pBCk3zRLxEFVKgpXrEzSosGnpM3skRS0DwWSg791V+WInTFfp5xjFOfoI8+qqtQEofumsF4bYtbNI+Ewu0cxBZyNyvu+GQZQojj/4XoErLEMR5t/lA0Czn9/lDA240CmgpGgmSXNcZe2LVp630scvhD6qt9M3HdnbQoA9AfOboKQ1yEY8WE24tpRmgvjsgJ7hpi4eYsvH916nJnKqDDM9zIhFLnUoUfmstz387mHyya8ZbNwXdGISATkU2jFLRnZ/tsqwJdP94UCVQicpmYPHlBEL2y7Ir3lvuDfa4t7UXCueXFLan7pmiS7VKPRPM7UYE4vuYlyxCU6m3E6rsgvb1y7R6mTTmaMWD5c9bX6SHZG45wNypN/AaC2GQItu5CInt8GIiBMzz6hRJku1n2DmStRwqEydKteTjfDXWM8Z7x2XME3EBe2HrUzyHGkDiSxqSZPTF4OMasRsnMUTg3lYCyC/p313HHhFn/KeDTggyt7k9mge7rNMlwnjDm+nraxMOUQGsT8UW44Z2BdSZI95Ui8PAvjAbZoUzGBAIoI3LPRvTD+/4RITWK+HvwGpr64DWHn65pRL
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e91a65f5-aa9d-4af8-993f-08db06069a90
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 16:49:23.5482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QZWPv6bFHDoG4TT6ICJTtN/Kn0LaGHQn+7llF5txMaSWXf/KdF96R7nfc3fgUVmxeZneTpJjdy+uHEP+u5uSsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8506
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Hannes,

On Fri, Jan 27, 2023 at 04:34:59PM +0100, Hannes Reinecke wrote:
> > @@ -691,6 +708,15 @@ enum scsi_disposition scsi_check_sense(struct scsi=
_cmnd *scmd)
> >   		}
> >   		return SUCCESS;
> > +	case COMPLETED:
> > +		if (sshdr.asc =3D=3D 0x55 && sshdr.ascq =3D=3D 0x0a) {
> > +			set_scsi_ml_byte(scmd, SCSIML_STAT_DL_TIMEOUT);
> > +			req->cmd_flags |=3D REQ_FAILFAST_DEV;
> > +			req->rq_flags |=3D RQF_QUIET;
> > +			return SUCCESS;
>=20
> You can kill this line, will be done anyway.

Thanks, we will fix in next revision.

>=20
> > +		}
> > +		return SUCCESS;
> > +
> >   	default:
> >   		return SUCCESS;
> >   	}
> > @@ -785,6 +811,14 @@ static enum scsi_disposition scsi_eh_completed_nor=
mally(struct scsi_cmnd *scmd)
> >   	switch (get_status_byte(scmd)) {
> >   	case SAM_STAT_GOOD:
> >   		scsi_handle_queue_ramp_up(scmd->device);
> > +		if (scmd->sense_buffer && SCSI_SENSE_VALID(scmd))
> > +			/*
> > +			 * If we have sense data, call scsi_check_sense() in
> > +			 * order to set the correct SCSI ML byte (if any).
> > +			 * No point in checking the return value, since the
> > +			 * command has already completed successfully.
> > +			 */
> > +			scsi_check_sense(scmd);
>=20
> I am every so slightly nervous here.
> We never checked the sense code for GOOD status, so heaven knows if there
> are devices out there which return something here.

Well, right now we have had quite the opposite problem, to even allow
sense data while not being a CHECK_COMMAND, since they have been very
intertwined historically.

That alone makes me seriously doubt that this is going to be a problem.

But if there is a device that returns sense data when it shouldn't,
that is obviously a spec violation, and I assume that we would deal
with it in the same way we usually do, i.e. a device that does not
follow the spec has to be quirked. However, right now, I think that
it is sheer speculation that such a device even exists.

> And you have checked that we've cleared the sense code before submitting =
(or
> retrying, even), right?

Yes, scsi_queue_rq() does an unconditionall memset(cmd->sense_buffer, ...).

A retried command will call scsi_queue_insert() -> blk_mq_requeue_request()=
,
which will eventually reach blk_mq_dispatch_rq_list(), which will again lea=
d
to scsi_queue_insert() getting called (which will memset the sense_buffer).

>=20
> >   		fallthrough;
> >   	case SAM_STAT_COMMAND_TERMINATED:
> >   		return SUCCESS;
> > @@ -1807,6 +1841,10 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
> >   		return !!(req->cmd_flags & REQ_FAILFAST_DRIVER);
> >   	}
> > +	/* Never retry commands aborted due to a duration limit timeout */
> > +	if (scsi_ml_byte(scmd->result) =3D=3D SCSIML_STAT_DL_TIMEOUT)
> > +		return true;
> > +
> >   	if (!scsi_status_is_check_condition(scmd->result))
> >   		return false;
> > @@ -1966,6 +2004,14 @@ enum scsi_disposition scsi_decide_disposition(st=
ruct scsi_cmnd *scmd)
> >   		if (scmd->cmnd[0] =3D=3D REPORT_LUNS)
> >   			scmd->device->sdev_target->expecting_lun_change =3D 0;
> >   		scsi_handle_queue_ramp_up(scmd->device);
> > +		if (scmd->sense_buffer && SCSI_SENSE_VALID(scmd))
> > +			/*
> > +			 * If we have sense data, call scsi_check_sense() in
> > +			 * order to set the correct SCSI ML byte (if any).
> > +			 * No point in checking the return value, since the
> > +			 * command has already completed successfully.
> > +			 */
> > +			scsi_check_sense(scmd);
> >   		fallthrough;
> >   	case SAM_STAT_COMMAND_TERMINATED:
> >   		return SUCCESS;
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index e1a021dd4da2..406952e72a68 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -600,6 +600,8 @@ static blk_status_t scsi_result_to_blk_status(int r=
esult)
> >   		return BLK_STS_MEDIUM;
> >   	case SCSIML_STAT_TGT_FAILURE:
> >   		return BLK_STS_TARGET;
> > +	case SCSIML_STAT_DL_TIMEOUT:
> > +		return BLK_STS_DURATION_LIMIT;
> >   	}
> >   	switch (host_byte(result)) {
> > @@ -797,6 +799,8 @@ static void scsi_io_completion_action(struct scsi_c=
mnd *cmd, int result)
> >   				blk_stat =3D BLK_STS_ZONE_OPEN_RESOURCE;
> >   			}
> >   			break;
> > +		case COMPLETED:
> > +			fallthrough;
> >   		default:
> >   			action =3D ACTION_FAIL;
> >   			break;
> > diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> > index 74324fba4281..f42388ecb024 100644
> > --- a/drivers/scsi/scsi_priv.h
> > +++ b/drivers/scsi/scsi_priv.h
> > @@ -27,6 +27,7 @@ enum scsi_ml_status {
> >   	SCSIML_STAT_NOSPC		=3D 0x02,	/* Space allocation on the dev failed *=
/
> >   	SCSIML_STAT_MED_ERROR		=3D 0x03,	/* Medium error */
> >   	SCSIML_STAT_TGT_FAILURE		=3D 0x04,	/* Permanent target failure */
> > +	SCSIML_STAT_DL_TIMEOUT		=3D 0x05, /* Command Duration Limit timeout *=
/
> >   };
> >   static inline u8 scsi_ml_byte(int result)
>=20
> Cheers,
>=20
> Hannes
> =
