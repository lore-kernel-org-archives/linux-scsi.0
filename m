Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2011EC33CA2
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 05:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5A5A2073A
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 05:56:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QdtEvRbW";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="NXA76IVN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgAIF4N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jan 2020 00:56:13 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:44854 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgAIF4M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jan 2020 00:56:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1578549372; x=1610085372;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=ZHEVuzmb4UEKQwjVVJUA3uvW+u0sNLM/oT4nxostcow=;
  b=QdtEvRbW5J0UiQHY2FA8snwa+xu6N3l34JBuFDCr5TDDTHmzdu1yaNnB
   8LkZxwebYvIGGfiwj1oSX0XTbTJSsUVuhqOChgSrJZFrzjUvxzbcOTwNG
   teBTX1UVilDbbZALYqvkpqCaMpPv6FL8M8Si8WpUPcCQjzZBpG4pAVZfL
   py67Jj/Jgs+UH56w2/E2QaNY2VT8g5C/JvltsRb8rwqIoYURYCNbzQTf+
   PAln3jqPtgx21PpfR5cdk6t57+k63Rd6zHqInEeEsAlk/neEgvRotFMNs
   6JxrMq/bEhoIVJ2CtAN1VwxtnHaJDRHND9tXPXbwr/QPfiXEq8O1s6zhZ
   g==;
IronPort-SDR: urxJVJLCyDd+mDzSGckJeoLkOuwP6O5lINwU6xqk4bUtlIYsAdByprxJV2ucVoFngoUO1DuDvj
 ImPQrM80AgLGnNmcd0vzZbQ5g4v3PAmW5+rX46GK8kSkUettoSt6jj6OKdIj2DU2To8ttVZUC/
 x1wXq78gX35lkqnsiBNunbiScWxIlO92jcJF2s1zdTMnA6aaFDY9C7liuesiIgygymKSGAT+/f
 e8y5A53f/VFzfTlcvizhzGi9Cx82l09GE3Xh38ydTDH+R8momFComWtt7SYzgSwgdz7KQhbG5I
 emU=
X-IronPort-AV: E=Sophos;i="5.69,412,1571673600"; 
   d="scan'208";a="128589171"
Received: from mail-bl2nam02lp2054.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.54])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jan 2020 13:56:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a14rCi9/ieKdpjGWaxIGjBKSYakqKmM3WF2g5xbW61k/nhhyHZUSj6PqyHw3ILVrmDaXtSRBz8AMpEqz5heHHzKYKAdiMbq37PdwxxdK07+cfccSUvNz9GhomLLBtckMRaJOLxEcT5mMcEc5FqTYYhanRMNaHSGtL3gztyWGlfe7zetJ6IBLqVx0I7VhhesAL6GOFBEgTUSKFpIw8K2SsTrdnFla7Kgg4LXDFlK2dmnOlyLLSUfWo4h9gSGBLBTiy2VqPkZPsHIgHU/Z3U8qIDx1q1zY1kd9ablNPKNM+/je6RhS6HSCxQ8I6ZDFtcrlGLCCzmjVCGDoiBO3guJyLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=koKtRxADV1R/sFPrSbfoc5b/Ra0klyuwVaKAmAjcrVg=;
 b=AOtW0mejbgVBKFvTOCkB6jUscpfyVnA9cRvzBqIQDrr29AUW+WxPrlLPtjZStUUxJiMXPWLXOjI4jBeOR8u1b2qE6+4jpg2Pr03xJeUwA+MAWXTGQlbrS521Bn17PxSmxnVuqzWfSqWw5z+cZ4Yi6dSpNdPwJHQppNjzlH0OGirdbn0b6i9x3zP0LEK0lNLRuYM+M1dG3RM4cAcYSM1TWewQjMVYGFp8alTCT8MluAXkgH16RByWWnDXdL32q8TaDg3xKXY3mJ2KyEhm25UbtkyUQfqD26bUK5SXNQO8giO+r/cqO70tlKb00dK/q+Tzz2pcJyzR4NM2Vh3WsdL2BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=koKtRxADV1R/sFPrSbfoc5b/Ra0klyuwVaKAmAjcrVg=;
 b=NXA76IVNpbd10F3/3ogFw298B78g4y1QBMp6HyUWQDoCUfFIzgPPptUcLD9sy/yJwVnx9T+nvxWxsl4N9BtmGdkhqTysd+N6FNC+RNxjI61To3WV4tU8kkbK8RqpR5QKnyQnIf6oSAJOLnkTbZOCrLrkrJq7TVse3kum2UZwubM=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB4104.namprd04.prod.outlook.com (52.135.216.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Thu, 9 Jan 2020 05:56:07 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::cd8e:d1de:e661:a61]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::cd8e:d1de:e661:a61%5]) with mapi id 15.20.2602.018; Thu, 9 Jan 2020
 05:56:07 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>, "hare@suse.de" <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Stephen Bates <sbates@raithlin.com>,
        "msnitzer@redhat.com" <msnitzer@redhat.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "zach.brown@ni.com" <zach.brown@ni.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "frederick.knight@netapp.com" <frederick.knight@netapp.com>,
        Matias Bjorling <Matias.Bjorling@wdc.com>
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Topic: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Index: AQHVxYZFlOEpmvYia0KWnm3aEM0giQ==
Date:   Thu, 9 Jan 2020 05:56:07 +0000
Message-ID: <BYAPR04MB581697B0367321CBAD04F9C4E7390@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <BYAPR04MB5749820C322B40C7DBBBCA02863F0@BYAPR04MB5749.namprd04.prod.outlook.com>
 <fda88fd3-2d75-085e-ca15-a29f89c1e781@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 30013d1d-c0d6-4932-3369-08d794c89eca
x-ms-traffictypediagnostic: BYAPR04MB4104:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB4104C06BB1FB727ECDBD2DD4E7390@BYAPR04MB4104.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02778BF158
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(199004)(189003)(53546011)(110136005)(26005)(33656002)(5660300002)(7696005)(7416002)(81156014)(316002)(9686003)(91956017)(186003)(6506007)(66446008)(54906003)(86362001)(55016002)(66556008)(66946007)(66476007)(81166006)(52536014)(966005)(64756008)(76116006)(8936002)(45080400002)(2906002)(4326008)(8676002)(71200400001)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4104;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VbVaehMrledWPt6yMkpUavA4DRfF9v7kg8nwoeYLBvRzhHJQwjy0xq3obGRFeWS/l9yjYZbsiLc2nJ4M0JVu3fzd0bGWjCbhyHyWNZ2xtrK/V3+oAsJZABh93B3H7wUIFk5YpqgmtAmf51/albk1WyP/G64SO6inCPXB7CEmOXq7JwMlnDKIyCaKNzhuT4Gdm4KjRJ5cKxFFBHyVTz0WedvPihsFFNP+NQ7PUQVYnGGUdApOYOsV6Ig1G8yEXkC4Y0lZ+c0mdu5oML02g2e7b9nFBeipLI386BnR6WHr4f/JzPTx9BD6bkos8iNHmQ82Wfip5Krca5v+CxzJ3UDV8iHzf2o3RbiUcsH6P071vf7LUK8jFwRpTEgrIfZnB4AaoA4q1cceNl+SGh8vgMudJFI6qmc3IFGa5U7KCHWB+KhWy299Fv+x6smk9nl354IKWyCAJqKjI/UJcPfW7RICTFhfZ6dnG2LAEubY+QHxhD2MvYl4lSBkFHAYhRPIfFiezXm9WWugz0iFVPbuS1YD+g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30013d1d-c0d6-4932-3369-08d794c89eca
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2020 05:56:07.3216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rGijyZy3owj+ys5nDb+xMAafJee9QabF9eFAn1SghlwLoSOilMql7s4jL+lDmEiKIneg/szVFeQl/2Wrjsn9FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4104
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/01/09 12:19, Bart Van Assche wrote:=0A=
> On 2020-01-07 10:14, Chaitanya Kulkarni wrote:=0A=
>> * Current state of the work :-=0A=
>> -----------------------------------------------------------------------=
=0A=
>>=0A=
>> With [3] being hard to handle arbitrary DM/MD stacking without=0A=
>> splitting the command in two, one for copying IN and one for copying=0A=
>> OUT. Which is then demonstrated by the [4] why [3] it is not a suitable=
=0A=
>> candidate. Also, with [4] there is an unresolved problem with the=0A=
>> two-command approach about how to handle changes to the DM layout=0A=
>> between an IN and OUT operations.=0A=
> =0A=
> Was this last discussed during the 2018 edition of LSF/MM (see also=0A=
> https://www.spinics.net/lists/linux-block/msg24986.html)? Has anyone=0A=
> taken notes during that session? I haven't found a report of that=0A=
> session in the official proceedings (https://lwn.net/Articles/752509/).=
=0A=
=0A=
Yes, I think it was discussed but I do not think much progress has been=0A=
made. With NVMe simple copy added to the potential targets, I think it=0A=
is worthwhile to have this discussion again and come up with a clear plan.=
=0A=
=0A=
> =0A=
> Thanks,=0A=
> =0A=
> Bart.=0A=
> =0A=
> =0A=
> This is my own collection with two year old notes about copy offloading=
=0A=
> for the Linux Kernel:=0A=
> =0A=
> Potential Users=0A=
> * All dm-kcopyd users, e.g. dm-cache-target, dm-raid1, dm-snap, dm-thin,=
=0A=
>   dm-writecache and dm-zoned.=0A=
> * Local filesystems like BTRFS, f2fs and bcachefs: garbage collection=0A=
>   and RAID, at least if RAID is supported by the filesystem. Note: the=0A=
>   BTRFS_IOC_CLONE_RANGE ioctl is no longer supported. Applications=0A=
>   should use FICLONERANGE instead.=0A=
> * Network filesystems, e.g. NFS. Copying at the server side can reduce=0A=
>   network traffic significantly.=0A=
> * Linux SCSI initiator systems connected to SAN systems such that=0A=
>   copying can happen locally on the storage array. XCOPY is widely used=
=0A=
>   for provisioning virtual machine images.=0A=
> * Copy offloading in NVMe fabrics using PCIe peer-to-peer communication.=
=0A=
> =0A=
> Requirements=0A=
> * The block layer must gain support for XCOPY. The new XCOPY API must=0A=
>   support asynchronous operation such that users of this API are not=0A=
>   blocked while the XCOPY operation is in progress.=0A=
> * Copying must be supported not only within a single storage device but=
=0A=
>   also between storage devices.=0A=
> * The SCSI sd driver must gain support for XCOPY.=0A=
> * A user space API must be added and that API must support asynchronous=
=0A=
>   (non-blocking) operation.=0A=
> * The block layer XCOPY primitive must be support by the device mapper.=
=0A=
> =0A=
> SCSI Extended Copy (ANSI T10 SPC)=0A=
> The SCSI commands that support extended copy operations are:=0A=
> * POPULATE TOKEN + WRITE USING TOKEN.=0A=
> * EXTENDED COPY(LID1/4) + RECEIVE COPY STATUS(LID1/4). LID1 stands for a=
=0A=
>   List Identifier length of 1 byte and LID4 stands for a List Identifier=
=0A=
>   length of 4 bytes.=0A=
> * SPC-3 and before define EXTENDED COPY(LID1) (83h/00h). SPC-4 added=0A=
>   EXTENDED COPY(LID4) (83h/01h).=0A=
> =0A=
> Existing Users and Implementations of SCSI XCOPY=0A=
> * VMware, which uses XCOPY (with a one-byte length ID, aka LID1).=0A=
> * Microsoft, which uses ODX (aka LID4 because it has a four-byte length=
=0A=
>   ID).=0A=
> * Storage vendors all support XCOPY, but ODX support is growing.=0A=
> =0A=
> Block Layer Notes=0A=
> The block layer supports the following types of block drivers:=0A=
> * blk-mq request-based drivers.=0A=
> * make_request drivers.=0A=
> =0A=
> Notes:=0A=
> With each request a list of bio's is associated.=0A=
> Since submit_bio() only accepts a single bio and not a bio list this=0A=
> means that all make_request block drivers process one bio at a time.=0A=
> =0A=
> Device Mapper=0A=
> The device mapper core supports bio processing and blk-mq requests. The=
=0A=
> function in the device mapper that creates a request queue is called=0A=
> alloc_dev(). That function not only allocates a request queue but also=0A=
> associates a struct gendisk with the request queue. The=0A=
> DM_DEV_CREATE_CMD ioctl triggers a call of alloc_dev(). The=0A=
> DM_TABLE_LOAD ioctl loads a table definition. Loading a table definition=
=0A=
> causes the type of a dm device to be set to one of the following:=0A=
> DM_TYPE_NONE;=0A=
> DM_TYPE_BIO_BASED;=0A=
> DM_TYPE_REQUEST_BASED;=0A=
> DM_TYPE_MQ_REQUEST_BASED;=0A=
> DM_TYPE_DAX_BIO_BASED;=0A=
> DM_TYPE_NVME_BIO_BASED.=0A=
> =0A=
> Device mapper drivers must implement target_type.map(),=0A=
> target_type.clone_and_map_rq() or both. .map() maps a bio list.=0A=
> .clone_and_map_rq() maps a single request. The multipath and error=0A=
> device mapper drivers implement both methods. All other dm drivers only=
=0A=
> implement the .map() method.=0A=
> =0A=
> Device mapper bio processing=0A=
> submit_bio()=0A=
> -> generic_make_request()=0A=
>   -> dm_make_request()=0A=
>     -> __dm_make_request()=0A=
>       -> __split_and_process_bio()=0A=
>         -> __split_and_process_non_flush()=0A=
>           -> __clone_and_map_data_bio()=0A=
>           -> alloc_tio()=0A=
>           -> clone_bio()=0A=
>             -> bio_advance()=0A=
>           -> __map_bio()=0A=
> =0A=
> Existing Linux Copy Offload APIs=0A=
> * The FICLONERANGE ioctl. From <include/linux/fs.h>:=0A=
>   #define FICLONERANGE _IOW(0x94, 13, struct file_clone_range)=0A=
> =0A=
> struct file_clone_range {=0A=
> 	__s64 src_fd;=0A=
> 	__u64 src_offset;=0A=
> 	__u64 src_length;=0A=
> 	__u64 dest_offset;=0A=
> };=0A=
> =0A=
> * The sendfile() system call. sendfile() copies a given number of bytes=
=0A=
>   from one file to another. The output offset is the offset of the=0A=
>   output file descriptor. The input offset is either the input file=0A=
>   descriptor offset or can be specified explicitly. The sendfile()=0A=
>   prototype is as follows:=0A=
>   ssize_t sendfile(int out_fd, int in_fd, off_t *ppos, size_t count);=0A=
>   ssize_t sendfile64(int out_fd, int in_fd, loff_t *ppos, size_t count);=
=0A=
> * The copy_file_range() system call. See also vfs_copy_file_range(). Its=
=0A=
>   prototype is as follows:=0A=
>   ssize_t copy_file_range(int fd_in, loff_t *off_in, int fd_out,=0A=
>      loff_t *off_out, size_t len, unsigned int flags);=0A=
> * The splice() system call is not appropriate for adding extended copy=0A=
>   functionality since it copies data from or to a pipe. Its prototype is=
=0A=
>   as follows:=0A=
>   long splice(struct file *in, loff_t *off_in, struct file *out,=0A=
>     loff_t *off_out, size_t len, unsigned int flags);=0A=
> =0A=
> Existing Linux Block Layer Copy Offload Implementations=0A=
> * Martin Petersen's REQ_COPY bio, where source and destination block=0A=
>   device are both specified in the same bio. Only works for block=0A=
>   devices. Does not work for files. Adds a new blocking ioctl() for=0A=
>   XCOPY from user space.=0A=
> * Mikulas Patocka's approach: separate REQ_OP_COPY_WRITE and=0A=
>   REQ_OP_COPY_READ operations. These are sent individually down stacked=
=0A=
>   drivers and are paired by the driver at the bottom of the stack.=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
