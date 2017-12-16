From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: Driver version for PMC Adaptec HBA in Linux and from vendor
Date: Sat, 16 Dec 2017 10:39:14 +0100
Message-ID: <71e28514-9832-5fae-ba69-1a6cbe5ae269@molgen.mpg.de>
References: <f09c20d4-dd38-d619-3b31-7782f9b5c0de@molgen.mpg.de>
 <4D8E82A446BF54499747901DBDEB737A7B8C48D8@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:37232 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751449AbdLPJjR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Dec 2017 04:39:17 -0500
In-Reply-To: <4D8E82A446BF54499747901DBDEB737A7B8C48D8@avsrvexchmbx2.microsemi.net>
Content-Language: de-DE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, aacraid@microsemi.com
Cc: linux-scsi@vger.kernel.org, it+linux-scsi@vger.kernel.org

Dear Aditya,


Am 17.02.2017 um 20:29 schrieb Raghava Aditya Renukunta:

>> Using a PMC Adaptec HBA 1000-8e with latest Linux, it only initializes
>> in sync mode, instead of async mode.
> 
> The patches that enable async mode in HBA 1000-8e, have been included in the James Bottomley's linux-scsi Branch and are on track be
> Included into Linux 4.11.
> 
> https://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git/
> 
>> ```
>> $ git describe --tag
>> v4.10-rc8-47-g0722f57bf
>> $ dmesg
>> [   21.359635] Adaptec aacraid driver 1.2-1[41066]-ms
>> [   21.360017] aacraid 0000:04:00.0: can't disable ASPM; OS doesn't have
>> ASPM control
>> [   21.363987] AAC0: Async. mode not supported by current driver, sync.
>> mode enforced.
>> [   21.363987] Please update driver to get full performance.
>> [   21.364949] AAC0: kernel 1.2-0[0] Nov  5 2015
>> [   21.365275] AAC0: monitor 0.0-0[0]
>> [   21.371382] AAC0: bios 0.13-209[32000]
>> [   21.371711] AAC0: serial 10F447
>> [   21.372035] AAC0: Non-DASD support enabled.
>> [   21.372360] AAC0: 64bit support enabled.
>> [   21.372688] AAC0: 64 Bit DAC enabled
>> […]
>> $ git grep 'AAC_DRIVER_BUILD 41066'
>> drivers/scsi/aacraid/aacraid.h:# define AAC_DRIVER_BUILD 41066
>> ```
>>
>> Searching the vendor Web site, there is *Linux Driver Source
>> 1.2.1-53005* available for download [1].
> 
> The latest upstream driver version is 50740. We will be reaching version 53005 in couple of patch sets  ( ~ 3).
> 
> http://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git/commit/?id=96f6a6134766de0d42a98c7758736dde16e0add5

Thank you for the details. At our infrastructure we only want to use LTS 
Linux kernels, and the latest in 4.14. So right now, Linux 4.14.6 
includes version 50834 [1], which is the same version currently in Linus 
master branch (4.15-rc3). Is that save to use with async mode, or are 
you aware of problems and we should always use the latest out of tree 
driver, which is at version 55022 and can be download from the Microsemi 
server [3].

>> How does the upstream process work? Is there a git repository somewhere
>> from Microsemi? Are the patches already up for review? (I didn’t find them.)
> 
> We try to push out patch sets to kernel.org for every major  driver release we make.  Usually they go into the
> sub component maintainers branch (linux-scsi ) , which is then pushed out to Linus when the merge
> window for  opens (currently the merge window for 4.10 is closed , barring fixes). So Linux version 4.11 should have
> full async support and more for HBA1000-8e.
> 
> We do not maintain a git repository unfortunately, but we do release the source code for every release as you
> indicated.
> 
> For further reference the patches are sent out in the scsi mailing list linux-scsi@vger.kernel.org ,
> the archive is here http://marc.info/?l=linux-scsi&r=1&w=2 .
> 
> Hope I cleared up your doubts. Please do reach out if you have other concerns or questions.

Yes, thank you for your elaborate answer, which cleared up a lot of my 
doubts. We would be even more satisfied if you moved your development 
fully to the Linux kernel tree, so that it always carries the latest 
driver. If we can help with that by contacting certain people, please 
tell us.


Kind regards,

Paul


>> [1] https://storage.microsemi.com/en-us/speed/raid/aac/linux/aacraid-linux-src-1_2_1-53005_tgz.php
[2] 
https://elixir.free-electrons.com/linux/v4.14.6/source/drivers/scsi/aacraid/aacraid.h#L100
[3] 
https://storage.microsemi.com/en-us/downloads/linux_source/linux_source_code/productid=aha-1000-8e&dn=microsemi+adaptec+hba+1000-8e.php
