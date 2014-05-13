From: Nathan Shearer <mail@nathanshearer.ca>
Subject: Re: Hot Swap Problems with LSI HBA and LSI Backplane -- reproducable
 and very frustrating
Date: Tue, 13 May 2014 11:25:58 -0600
Message-ID: <537255A6.1070401@nathanshearer.ca>
References: <523A23D3.6030608@nathanshearer.ca> <CAC9+an+YaZ3hn+eTyk0mApgj7m30yTYEKeif=aEUrF49dinh7w@mail.gmail.com> <523BE569.4020706@nathanshearer.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from whm03.asteroidpc.com ([204.191.218.7]:43633 "EHLO
	whm03.asteroidpc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaEMRZ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 May 2014 13:25:59 -0400
Received: from [207.228.103.62] (port=60346 helo=[10.13.1.20])
	by whm03.asteroidpc.com with esmtpsa (TLSv1:DHE-RSA-AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <mail@nathanshearer.ca>)
	id 1WkGSl-0003nc-El
	for linux-scsi@vger.kernel.org; Tue, 13 May 2014 11:25:59 -0600
In-Reply-To: <523BE569.4020706@nathanshearer.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hi Nicolas,

I just wanted to be sure that you are experiencing the same problem. In 
my final setup I wanted to use a Supermicro SuperChassis 826E2-R800LPB 
<http://www.supermicro.com/products/chassis/2U/826/SC826TQ-R800LP.cfm> 
with a LSI SAS9207-8i 
<http://www.lsi.com/products/host-bus-adapters/pages/lsi-sas-9207-8i.aspx#two> 
and a mixture of hard drives.

I included the linux-scsi mailing list for future reference, but I'm 
afraid I have bad news. I contacted Supermicro and LSI regarding this 
issue and after a lot of back-and-forth and testing on my part this is 
what I determined:

  * Supermicro Case Number: SM1309158401
  * LSI Case Number: P00078977
  * Seagate Case Number: 03671535
  * The LSI SAS9207-8i
    <http://www.lsi.com/products/host-bus-adapters/pages/lsi-sas-9207-8i.aspx#two>
    uses the LSI SAS2308 controller, is SAS 2.1 compliant, and has the
    same problem
  * The Supermicro AOC-USAS2-L8i
    <http://www.supermicro.com/products/accessories/addon/AOC-USAS2-L8i.cfm>
    uses the LSI SAS2008
    <http://www.lsi.com/products/io-controllers/pages/lsi-sas-2008.aspx>
    controller, is SAS 2.0 compliant, and has the same problem
  * The Supermicro AOC-USAS-L8i
    <http://www.supermicro.com/products/accessories/addon/aoc-usas-l8i.cfm>
    uses the LSI SAS1068E
    <http://www.lsi.com/products/io-controllers/pages/lsi-sas-1068e.aspx> controller,
    is SAS 1.0 compliant, and *works perfectly
    *
      o Note that this card does not support hard drives with >2TB of space
      o All drives work (including the ones affected on the newer
        controller), but they have exactly 2^32 bytes of usable space
  * Supermicro SuperChassis 826E2-R800LPB
    <http://www.supermicro.com/products/chassis/2U/826/SC826TQ-R800LP.cfm>
    uses the BPN-SAS-826EL2 backplane (SAS 1.0)
  * The BPN-SAS-826EL2 uses the LSI SASx28
    <http://www.lsi.com/products/sas-expanders/pages/lsi-sas-x28.aspx>
    expander chipset (SAS 1.0)
  * LSI has discontinued support for the LSI SASx28
    <http://www.lsi.com/products/sas-expanders/pages/lsi-sas-x28.aspx>
    over 2 years ago!
  * Supermicro refused to provide support or a new firmware for the
    backplane or LSI SASx28 expander. They told me to contact Supermicro
    for a new backplane firmware or a new backplane.
  * I forwarded my entire e-mail chain from LSI to Supermicro and
    Supermicro said that LSI discontinued support over 2 years ago and
    that there is no newer firmware.
  * *To solve the issue, You need to replace the SAS1 backplane
    (BPN-SAS-826EL2)**with a SAS2 packplane: **BPN-SAS2-826EL2*
      o I did not try this -- I can't guarantee that it will work

I believe it is a problem with the SAS1 backplane and SAS2 controller 
card. Why only certain drives are affected, I'm not sure. My guess is 
it's a power-saving feature that is causing them to not spin up 
properly, then the controller/backplane disables the drive bay 
permanently for some reason. It is something related to mixing the SAS2 
controller with the SAS1 backplane. A SAS2 backplane might fix the issue.

I am still using the Supermicro SuperChassis 826E2-R800LPB with the 
BPN-SAS-826EL2 backplane with the LSI SASx28 expander chipset, all with 
a LSI SAS9207-8i controller. In my particular situation we decided to 
just go with drives that work from the compatibility list -- which is 
very expensive, but I needed the guarantee that they would work.

With that configuration, I did some testing with various drives and this 
is what I found:

  * Western Digital WD2003FYYS-02W0B0 *works*
  * Western Digital WD20EARS-00S8B1*works*
  * Western Digital WD3000BLFS-01YBU4 *works*
  * Western Digital WD3000HLFS-01G6U1 *works*
  * Western Digital WD30EFRX-68AX9N0 *works *(but had some odd "task
    abort" kernel messages)
  * Western Digital WD740ADFD-00NLR5 *works*
  * Seagate ST3000DM001 /*failed*/
  * Seagate ST3500641AS *works*
  * Seagate ST4000DM000-1F2168 /*failed*/
  * Seagate ST91000640NS *works*

I also tried these drives on my HighPoint RocketRaid 2740 (direct 
attached SAS 2.0) without the backplane and all the drives worked perfectly.

