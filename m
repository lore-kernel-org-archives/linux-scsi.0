Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 601FAC4727C
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 16:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 208102395C
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 16:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgIVQQb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:16:31 -0400
Received: from 167-88-115-53.cloud.ramnode.com ([167.88.115.53]:60450 "EHLO
        durga.tabris.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbgIVQQb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2020 12:16:31 -0400
Received: from bragi.tabris.net (localhost [127.0.0.1])
        (Authenticated sender: mailrelay)
        by durga.tabris.net (Postfix) with ESMTPA id 81F85C3202F;
        Tue, 22 Sep 2020 09:16:30 -0700 (PDT)
Received: from sif.tabris.net (bragi.tabris.net [192.168.88.8])
        (Authenticated sender: tabris)
        by bragi.tabris.net (Postfix) with ESMTPA id 857DEC2C8525;
        Tue, 22 Sep 2020 12:16:29 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 bragi.tabris.net 857DEC2C8525
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by sif.tabris.net (Postfix) with ESMTP id 13B1320144;
        Tue, 22 Sep 2020 12:16:29 -0400 (EDT)
Subject: Re: bug in mpt3sas vs Lenovo 530-8i
To:     Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
References: <a29522ab-6246-00b6-57b9-cd8d7c8766dc@domedata.com>
 <CA+RiK66O-0giupGduKOvTEoSmn1H21u_1ROjqZRGFy4+JX2gmA@mail.gmail.com>
 <caf5a889-4235-1610-6476-305898d01a75@domedata.com>
 <CA+RiK67Jt8QP-TMNi_QzcO=12Q51Nqm7UmwGgHP6jOdnu92=-Q@mail.gmail.com>
 <5f228767-c31e-4718-e1b7-23e94d5ead02@domedata.com>
 <CA+RiK64_gYKqcupxSvp2DhqNPsu-RFnNVG=4Zo8vLUdRAKahRg@mail.gmail.com>
 <CA+RiK66LMANSDhVqn0kwqdcerTfZDaORo_spV5W1mb1n99mU_g@mail.gmail.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>
From:   Adam Schrotenboer <adam@domedata.com>
Message-ID: <9e4bd483-1984-baf9-56b5-8b58092aae03@domedata.com>
Date:   Tue, 22 Sep 2020 12:16:28 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <CA+RiK66LMANSDhVqn0kwqdcerTfZDaORo_spV5W1mb1n99mU_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/22/2020 06:55 AM, Suganath Prabu Subramani wrote:

>
>> User space utilities should be sending fw upload /ioctl commands.
>> In case if you are using an older utility, please switch to storcli/scrtnycli.
>> Also let us know the utility used in your server.

Eventually found sas2ircu.
removing it from my system appears to have made the crashes disappear.
Unclear if this means that it was loading/using the ioctl incorrectly or
this remains a kernel bug.

root@mercury:/etc# !lsof
lsof|grep mpt
poll_mpt3  612                     root  cwd       DIR               
8,3      312        128 /
poll_mpt3  612                     root  rtd       DIR               
8,3      312        128 /
poll_mpt3  612                     root  txt  
unknown                                        /proc/612/exe
sas2ircu  1096                     root    3u      CHR            
10,222      0t0      11796 /dev/mpt3ctl
root@mercury:/etc# dpkg -S sas2ircu
sas2ircu-status: /usr/share/doc/sas2ircu-status/copyright
sas2ircu-status: /usr/share/doc/sas2ircu-status/README.Debian
sas2ircu-status: /usr/share/doc/sas2ircu-status
sas2ircu-status: /usr/share/doc/sas2ircu-status/changelog.gz
sas2ircu: /usr/share/doc/sas2ircu/copyright
sas2ircu: /usr/share/doc/sas2ircu/changelog.Debian.gz
sas2ircu-status: /usr/sbin/sas2ircu-status
sas2ircu-status: /etc/init.d/sas2ircu-statusd
sas2ircu: /usr/share/doc/sas2ircu
sas2ircu: /usr/share/doc/sas2ircu/changelog.gz
sas2ircu-status: /usr/share/man/man8/sas2ircu-status.8.gz
sas2ircu: /usr/share/doc/sas2ircu/SAS2IRCU_User_Guide.pdf
sas2ircu: /usr/sbin/sas2ircu
root@mercury:/etc# apt show sas2ircu
Package: sas2ircu
Version: 16.00.00.00-2+Debian.buster.10
Priority: optional
Section: admin
Source: sas2ircu (16.00.00.00-2)
Maintainer: Adam Cécile (Le_Vert) <gandalf@le-vert.net>
Installed-Size: 1,495 kB
Download-Size: 883 kB
APT-Manual-Installed: yes
APT-Sources: http://hwraid.le-vert.net/debian buster/main amd64 Packages
Description: LSI Logic Fusion MPT SAS2 command line management tool
 Tool to read and setup LSI Logic Fusion MTP SAS2 HW RAID HBAs (mpt2sas
 driver).

