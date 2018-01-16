From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: A qla2xxx commit cause Linux no response, has not fixed in
 lastest version 4.15-rc6
Date: Tue, 16 Jan 2018 04:58:45 +0000
Message-ID: <8E5E47EC-8184-4D07-96D5-9D41E3D4520D@cavium.com>
References: <BC29A004BA570342A4CC0044A3845572010DCF3E30@H3CMLB12-EX.srv.huawei-3com.com>
 <1515821296.24576.94.camel@haakon3.daterainc.com>
 <74BFA730-FDBB-4912-B4E3-734A84C6A63A@cavium.com>
 <BC29A004BA570342A4CC0044A3845572010DCF828D@H3CMLB12-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <BC29A004BA570342A4CC0044A3845572010DCF828D@H3CMLB12-EX.srv.huawei-3com.com>
Content-Language: en-US
Content-ID: <2F1CFA7A92A3C544B23B0E1CBE808476@namprd07.prod.outlook.com>
Sender: target-devel-owner@vger.kernel.org
To: Changlimin <changlimin@h3c.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Tran, Quinn" <Quinn.Tran@cavium.com>, Jifuliang <fuliang_ji@h3c.com>, Zhangguanghui <zhang.guanghui@h3c.com>, Zhangzijian <zhang.zijian@h3c.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Chang,=20

> On Jan 15, 2018, at 4:27 PM, Changlimin <changlimin@h3c.com> wrote:
>=20
> Hi Himanshu,
>  The issue is: When insmod the qla2xxx.ko from 4.15-rc6, linux hang.

>From the log file attached. I see that you are trying to load driver from 4=
.9.x in 4.15.0-rc6.=20

[  279.898704] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.07.00.38-k-debug.

4.15.0-rc6 had driver version 10.00.00.02-k. Would you check if you have al=
l the driver changes pulled
in with kernel 4.15.0-rc6.

>  I have git bisect the commits.=20
>  The issue was introduced in commit: 726b85487067d7f5b23495bc33c484b8517c=
4074 qla2xxx: Add framework for async fabric discovery.
>  The previous commit is good: 5d964837c6a743193c63c8912f98834c7457ba5c ql=
a2xxx: Track I-T nexus as single fc_port struct .
>=20
> Regards
> Chang Limin
>=20
> -----Original Message-----
> From: Madhani, Himanshu [mailto:Himanshu.Madhani@cavium.com]=20
> Sent: Tuesday, January 16, 2018 12:58 AM
> To: Nicholas A. Bellinger
> Cc: changlimin (Cloud); Tran, Quinn; jifuliang (Cloud); zhangguanghui (Cl=
oud); zhangzijian (Cloud); target-devel; linux-scsi
> Subject: Re: A qla2xxx commit cause Linux no response, has not fixed in l=
astest version 4.15-rc6
>=20
> Hi Nic, Chang,
>=20
>> On Jan 12, 2018, at 9:28 PM, Nicholas A. Bellinger <nab@linux-iscsi.org>=
 wrote:
>>=20
>> Hi Chang & Co,
>>=20
>> (Adding list + Himanshu CC')
>>=20
>> On Sun, 2018-01-07 at 10:21 +0000, Changlimin wrote:
>>> Hi,
>>> It seems the qla2xxx commit cause Linux no response, has not fixed in l=
astest version 4.15-rc6.
>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g
>>> it/commit/?id=3D726b85487067d7f5b23495bc33c484b8517c4074
>>>=20
>>=20
>> Thanks for reporting + including debug log.  :)
>>=20
>>> lspci:
>>> 0a:00.0 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel=20
>>> to PCI Express HBA (rev 02)
>>> 0a:00.1 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel=20
>>> to PCI Express HBA (rev 02)
>>>=20
>>> syslog:
>>> qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.07.00=
.38-k.
>>> qla2xxx [0000:0a:00.0]-001a: : MSI-X vector count: 32.
>>> qla2xxx [0000:0a:00.0]-001d: : Found an ISP2532 irq 16 iobase 0xffffb0d=
5cc501000.
>>> qla2xxx [0000:0a:00.0]-00c6:1: MSI-X: Failed to enable support with 32 =
vectors, using 26 vectors.
>>> scsi host1: qla2xxx
>>> qla2xxx [0000:0a:00.0]-00fb:1: QLogic HPAJ764A - HP 8Gb Dual Channel PC=
I-e 2.0 FC HBA.
>>> qla2xxx [0000:0a:00.0]-00fc:1: ISP2532: PCIe (5.0GT/s x8) @ 0000:0a:00.=
0 hdma+ host#=3D1 fw=3D8.03.00 (90d5).
>>> qla2xxx [0000:0a:00.1]-001a: : MSI-X vector count: 32.
>>> qla2xxx [0000:0a:00.1]-001d: : Found an ISP2532 irq 17 iobase 0xffffb0d=
5cc5d9000.
>>> qla2xxx [0000:0a:00.1]-00c6:2: MSI-X: Failed to enable support with 32 =
vectors, using 26 vectors.
>>> scsi host2: qla2xxx
>>> qla2xxx [0000:0a:00.1]-00fb:2: QLogic HPAJ764A - HP 8Gb Dual Channel PC=
I-e 2.0 FC HBA.
>>> qla2xxx [0000:0a:00.1]-00fc:2: ISP2532: PCIe (5.0GT/s x8) @ 0000:0a:00.=
1 hdma+ host#=3D2 fw=3D8.03.00 (90d5).
>>> qla2xxx [0000:0a:00.0]-500a:1: LOOP UP detected (8 Gbps).
>>> qla2xxx [0000:0a:00.1]-500a:2: LOOP UP detected (8 Gbps).
>>>=20
>>> The attached file is the module log.
>>>=20
>>> Do you have any advice?
>>=20
>> Quinn & Himanshu folks, any comments..?
>>=20
>=20
> What is the issue here? I am not clear form the snippet above.
>=20
> One thing I noticed that, if you are using 4.15-rc6 driver version should=
 be 10.00.00.02-k but the snippet shows 8.07.00.38-k which tells me you mig=
ht=20
>=20
> Thanks,
> - Himanshu
> <qla2xxx-full.log.gz>

Thanks,
- Himanshu
