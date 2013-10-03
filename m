From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: [PATCH 0/3] target: Fixes for COMPARE_AND_WRITE backend I/O
 failure cases
Date: Thu, 3 Oct 2013 13:38:59 +0200
Message-ID: <20131003113859.GB541@glanzmann.de>
References: <1380672796-437-1-git-send-email-nab@daterainc.com>
 <20131002043157.GA3057@glanzmann.de>
 <1380691034.19256.36.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1380691034.19256.36.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hallo Nab,

> Please let me know if you encounter any issues, and a patch to address
> this bit should be along in the next 24-48 hours.

I just did a little bit of stress testing:

        - Rescan from 12 Initiators at the same time - PASS
        - Deployed 24 VMs over 12 Initiators at the same time 200 MB/s
          frontend traffic - PASS
        - Booted 24 VMs on 12 ESX servers at the same time - 120 MB/s
          frontend traffic - PASS
        - Did 24 svMotion at the same time - 400 MB/s backend traffic -
          10 MB/s frontend traffic using XCOPY. - PASS
        - Unloaded the target in production, ran 'grep se_tmr
          /proc/slabinfo' and loaded it again. And made sure that the
          VMs continued to run. - PASS

It looks pretty stable to me. I'll use it next week in a class and
report back if I had any issues whatsoever. This was with:

v3.12-rc3-4-g8a77fe9

Cheers,
        Thomas
