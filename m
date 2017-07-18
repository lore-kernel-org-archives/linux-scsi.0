From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH] scsi: default to scsi-mq
Date: Wed, 19 Jul 2017 00:24:53 +0800
Message-ID: <20170719002453.00002876@huawei.com>
References: <1499701840.3555.7.camel@wdc.com>
        <e3c07504-8538-f2f3-003a-01b72e0c07c6@huawei.com>
        <1499779970.3345.1.camel@wdc.com>
        <4cf7ed21-7cf4-a91a-8beb-ba5f92e4eaaf@huawei.com>
        <1499788012.2586.12.camel@wdc.com>
        <9c0db5bd-a623-c73e-9f44-a4cfad97e2c8@huawei.com>
        <581a258d-3da8-5b01-f528-0ce11b74b65e@huawei.com>
        <1499869093.8204.2.camel@wdc.com>
        <20170712235401.00004402@huawei.com>
        <20170714175641.00001cb0@huawei.com>
        <20170714124539.GA26686@lst.de>
        <20170718235803.000062b6@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:10318 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751590AbdGRQZO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jul 2017 12:25:14 -0400
In-Reply-To: <20170718235803.000062b6@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linuxarm@huawei.com" <linuxarm@huawei.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 18 Jul 2017 23:58:03 +0800
Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:

> On Fri, 14 Jul 2017 14:45:39 +0200
> "hch@lst.de" <hch@lst.de> wrote:
> 
> > On Fri, Jul 14, 2017 at 05:56:41PM +0800, Jonathan Cameron wrote:  
> > > Just wondering if you had any thoughts on how we can proceed with tracking
> > > down this regression?
> > > 
> > > I'm not familiar enough with the multiqueue code to really know where
> > > to start.
> > > 
> > > If there are any other tests that would be of use, let us know.    
> > 
> > Can you send the blktrace and perf output for each of the runs?
> > 
> > Thanks!  
> 
> Hi 
> 
> Sorry for the delay,

For perf what in particular would be of use?

Thanks,

Jonathan
> 
> blktrace for now (or at least the btt output based on blktrace).
> All runs are 1 minute of fio with reads and iodepth of 2048 as
> before. Just the summaries to keep this compact.  Also 6 disks
> were running but results just presented for first one.
> 
> mq disabled, noop scheduler
> 
> ==================== All Devices ====================
> 
>             ALL           MIN           AVG           MAX           N
> --------------- ------------- ------------- ------------- -----------
> 
> Q2Q               0.000003960   0.000008760   0.016291960     6849306
> Q2G               0.000000780   0.000001547   0.011354860     1420699
> G2I               0.000000660   0.000000975   0.011092540     1420699
> Q2M               0.000000340   0.000000431   0.003383260     5428608
> I2D               0.000000440   0.000196038   0.023731660     1420699
> M2D               0.000000480   0.001475398   0.023726860     5428608
> D2C               0.000022420   0.002887338   0.026416340     6849307
> Q2C               0.000025360   0.004098233   0.035045140     6849307
> 
> ==================== Device Overhead ====================
> 
>        DEV |       Q2G       G2I       Q2M       I2D       D2C
> ---------- | --------- --------- --------- --------- ---------
>  (  8,  0) |   0.0078%   0.0049%   0.0083%   0.9922%  70.4532%
> ---------- | --------- --------- --------- --------- ---------
>    Overall |   0.0078%   0.0049%   0.0083%   0.9922%  70.4532%
> 
> ==================== Device Merge Information ====================
> 
>        DEV |       #Q       #D   Ratio |   BLKmin   BLKavg   BLKmax    Total
> ---------- | -------- -------- ------- | -------- -------- -------- --------
>  (  8,  0) |  6849307  1420699     4.8 |        8       38      256 54794456
> 
> ==================== Device Q2Q Seek Information ====================
> 
>        DEV |          NSEEKS            MEAN          MEDIAN | MODE           
> ---------- | --------------- --------------- --------------- | ---------------
>  (  8,  0) |         6849307             0.0               0 | 0(6849307)
> ---------- | --------------- --------------- --------------- | ---------------
>    Overall |          NSEEKS            MEAN          MEDIAN | MODE           
>    Average |         6849307             0.0               0 | 0(6849307)
> 
> ==================== Device D2D Seek Information ====================
> 
>        DEV |          NSEEKS            MEAN          MEDIAN | MODE           
> ---------- | --------------- --------------- --------------- | ---------------
>  (  8,  0) |         1420699             0.0               0 | 0(1420699)
> ---------- | --------------- --------------- --------------- | ---------------
>    Overall |          NSEEKS            MEAN          MEDIAN | MODE           
>    Average |         1420699             0.0               0 | 0(1420699)
> 
> ==================== Plug Information ====================
> 
> 		            DEV |    # Plugs # Timer Us  | % Time Q Plugged
> ---------- | ---------- ----------  | ----------------
>  (  8,  0) |    1420699(         0) |   2.231949107%
> 
>        DEV |    IOs/Unp   IOs/Unp(to)
> ---------- | ----------   ----------
>  (  8,  0) |        1.0          0.0
> ---------- | ----------   ----------
>    Overall |    IOs/Unp   IOs/Unp(to)
>    Average |        1.0          0.0
> 
> ==================== Active Requests At Q Information ====================
> 
>        DEV |  Avg Reqs @ Q
> ---------- | -------------
>  (  8,  0) |           5.9
> 
> ==================== I/O Active Period Information ====================
> 
>        DEV |     # Live      Avg. Act     Avg. !Act % Live
> ---------- | ---------- ------------- ------------- ------
>  (  8,  0) |        340   0.175645918   0.001273008  99.28
> ---------- | ---------- ------------- ------------- ------
>  Total Sys |        340   0.175645918   0.001273008  99.28
> 
> # Total System
> #     Total System : q activity
>   0.145330280   0.0
>   0.145330280   0.4
>  60.145690780   0.4
>  60.145690780   0.0
> 
> #     Total System : c activity
>   0.145450660   0.5
>   0.145450660   0.9
>  60.151161760   0.9
>  60.151161760   0.5
> 
> 
> MQ none scheduler
> 
> ==================== All Devices ====================
> 
>             ALL           MIN           AVG           MAX           N
> --------------- ------------- ------------- ------------- -----------
> 
> Q2Q               0.000004000   0.000010185   0.011803940     5890750
> Q2G               0.000000320   0.000000763   0.011078580     1831198
> G2I               0.000001080   0.000001682   0.010839860     1831198
> Q2M               0.000000340   0.000000484   0.008391040     4059553
> I2D               0.000000560   0.000087068   0.014350600     1831198
> M2D               0.000000740   0.000874582   0.014343840     4059553
> D2C               0.000045440   0.001720173   0.022475360     5890751
> Q2C               0.000047940   0.002351043   0.027917120     5890751
> 
> ==================== Device Overhead ====================
> 
>        DEV |       Q2G       G2I       Q2M       I2D       D2C
> ---------- | --------- --------- --------- --------- ---------
>  (  8,  0) |   0.0101%   0.0222%   0.0142%   1.1512%  73.1664%
> ---------- | --------- --------- --------- --------- ---------
>    Overall |   0.0101%   0.0222%   0.0142%   1.1512%  73.1664%
> 
> ==================== Device Merge Information ====================
> 
>        DEV |       #Q       #D   Ratio |   BLKmin   BLKavg   BLKmax    Total
> ---------- | -------- -------- ------- | -------- -------- -------- --------
>  (  8,  0) |  6098099  1831198     3.3 |        8       25      256 47126008
> 
> ==================== Device Q2Q Seek Information ====================
> 
>        DEV |          NSEEKS            MEAN          MEDIAN | MODE           
> ---------- | --------------- --------------- --------------- | ---------------
>  (  8,  0) |         5890751             0.0               0 | 0(5890751)
> ---------- | --------------- --------------- --------------- | ---------------
>    Overall |          NSEEKS            MEAN          MEDIAN | MODE           
>    Average |         5890751             0.0               0 | 0(5890751)
> 
> ==================== Device D2D Seek Information ====================
> 
>        DEV |          NSEEKS            MEAN          MEDIAN | MODE           
> ---------- | --------------- --------------- --------------- | ---------------
>  (  8,  0) |         1831198            14.9               0 | 0(1788470)
> ---------- | --------------- --------------- --------------- | ---------------
>    Overall |          NSEEKS            MEAN          MEDIAN | MODE           
>    Average |         1831198            14.9               0 | 0(1788470)
> 
> ==================== Plug Information ====================
> 
>        DEV |    # Plugs # Timer Us  | % Time Q Plugged
> ---------- | ---------- ----------  | ----------------
>  (  8,  0) |          0(   1831198) |   1.413429756%
> 
>        DEV |    IOs/Unp   IOs/Unp(to)
> ---------- | ----------   ----------
>  (  8,  0) |        0.0          1.0
> ---------- | ----------   ----------
>    Overall |    IOs/Unp   IOs/Unp(to)
>    Average |        0.0          1.0
> 
> ==================== Active Requests At Q Information ====================
> 
>        DEV |  Avg Reqs @ Q
> ---------- | -------------
>  (  8,  0) |      103313.4
> 
> ==================== I/O Active Period Information ====================
> 
>        DEV |     # Live      Avg. Act     Avg. !Act % Live
> ---------- | ---------- ------------- ------------- ------
>  (  8,  0) |       3524   0.016706167   0.000374821  97.81
> ---------- | ---------- ------------- ------------- ------
>  Total Sys |       3524   0.016706167   0.000374821  97.81
> 
> # Total System
> #     Total System : q activity
>   0.192011040   0.0
>   0.192011040   0.4
>  60.191890980   0.4
>  60.191890980   0.0
> 
> #     Total System : c activity
>   0.192155040   0.5
>   0.192155040   0.9
>  60.193025700   0.9
>  60.193025700   0.5
> 
> mq-deadline
> 
> ==================== All Devices ====================
> 
>             ALL           MIN           AVG           MAX           N
> --------------- ------------- ------------- ------------- -----------
> 
> Q2Q               0.000004280   0.000021677   0.011974760     2767943
> Q2G               0.000000440   0.000000624   0.004582540     1784446
> G2I               0.000001060   0.000011345   0.010930560     1784446
> Q2M               0.000000400   0.000000497   0.000384020      983498
> I2D               0.000000840   0.005639927   1.439620540     1784446
> M2D               0.000001500   0.010220524   1.180956080      983498
> D2C               0.000062460   0.001896701   0.013208260     2767944
> Q2C               0.000066940   0.009172085   1.441107160     2767944
> 
> ==================== Device Overhead ====================
> 
>        DEV |       Q2G       G2I       Q2M       I2D       D2C
> ---------- | --------- --------- --------- --------- ---------
>  (  8,  0) |   0.0044%   0.0797%   0.0019%  39.6416%  20.6791%
> ---------- | --------- --------- --------- --------- ---------
>    Overall |   0.0044%   0.0797%   0.0019%  39.6416%  20.6791%
> 
> ==================== Device Merge Information ====================
> 
>        DEV |       #Q       #D   Ratio |   BLKmin   BLKavg   BLKmax    Total
> ---------- | -------- -------- ------- | -------- -------- -------- --------
>  (  8,  0) |  6224597  1784446     3.5 |        8       12      256 22143552
> 
> ==================== Device Q2Q Seek Information ====================
> 
>        DEV |          NSEEKS            MEAN          MEDIAN | MODE           
> ---------- | --------------- --------------- --------------- | ---------------
>  (  8,  0) |         2767944             0.0               0 | 0(2767944)
> ---------- | --------------- --------------- --------------- | ---------------
>    Overall |          NSEEKS            MEAN          MEDIAN | MODE           
>    Average |         2767944             0.0               0 | 0(2767944)
> 
> ==================== Device D2D Seek Information ====================
> 
>        DEV |          NSEEKS            MEAN          MEDIAN | MODE           
> ---------- | --------------- --------------- --------------- | ---------------
>  (  8,  0) |         1784446           358.3               0 | 0(1549194)
> ---------- | --------------- --------------- --------------- | ---------------
>    Overall |          NSEEKS            MEAN          MEDIAN | MODE           
>    Average |         1784446           358.3               0 | 0(1549194)
> 
> ==================== Plug Information ====================
> 
>        DEV |    # Plugs # Timer Us  | % Time Q Plugged
> ---------- | ---------- ----------  | ----------------
>  (  8,  0) |          0(   1784446) |   1.244944150%
> 
>        DEV |    IOs/Unp   IOs/Unp(to)
> ---------- | ----------   ----------
>  (  8,  0) |        0.0          1.0
> ---------- | ----------   ----------
>    Overall |    IOs/Unp   IOs/Unp(to)
>    Average |        0.0          1.0
> 
> ==================== Active Requests At Q Information ====================
> 
>        DEV |  Avg Reqs @ Q
> ---------- | -------------
>  (  8,  0) |     1731603.5
> 
> ==================== I/O Active Period Information ====================
> 
>        DEV |     # Live      Avg. Act     Avg. !Act % Live
> ---------- | ---------- ------------- ------------- ------
>  (  8,  0) |        554   0.108154299   0.000462375  99.58
> ---------- | ---------- ------------- ------------- ------
>  Total Sys |        554   0.108154299   0.000462375  99.58
> 
> # Total System
> #     Total System : q activity
>   0.167375140   0.0
>   0.167375140   0.4
>  60.167642920   0.4
>  60.167642920   0.0
> 
> #     Total System : c activity
>   0.167503100   0.5
>   0.167503100   0.9
>  60.173175400   0.9
>  60.173175400   0.5
> 
> Thanks
> 
> Jonathan
> 
> _______________________________________________
> linuxarm mailing list
> linuxarm@huawei.com
> http://rnd-openeuler.huawei.com/mailman/listinfo/linuxarm
