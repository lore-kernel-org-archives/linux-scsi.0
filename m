From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: iscsi_trx going into D state
Date: Fri, 6 Jan 2017 12:12:58 -0700
Message-ID: <CAANLjFocE2fbO_oWRiEVCt0=mfmgrLy9qWqqg=TH_jZS3PXn0g@mail.gmail.com>
References: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA@mail.gmail.com>
 <CAANLjFqvtqFu85Aivg6K8XB0rMub03KbBSCq8Kj=Cg+ybxu3pw@mail.gmail.com>
 <CAANLjFpbE9-B8qWtU5nDfg4+t+kD8TSVy0JOfN+zuFYsZ05_Dg@mail.gmail.com>
 <CAANLjFpEpJ4647u9R-7phf68fw--pOfThbp5Sntd4c7DdRSwwQ@mail.gmail.com>
 <CAANLjFooGrt51a9rOy8TKMyXyxBYmGEPm=h1YJm81Nj6YS=5yg@mail.gmail.com>
 <CAANLjFrZrTPUuzP_NjkgG5h_YwwYKEWT-KzVjTvuXZ1d04z6Fg@mail.gmail.com>
 <CAANLjFpSnQ7ApOK5HDRHXQQeQNGWLUv4e+2N=_e-zBeziYm5tw@mail.gmail.com>
 <CAANLjForEkO6RXw7KJYrTJD=f0S8FE73vvwNQcL_ARFdFoDQqg@mail.gmail.com> <1030906614.13148012.1483722413675.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34995 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033001AbdAFTNA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2017 14:13:00 -0500
Received: by mail-oi0-f66.google.com with SMTP id x84so4273391oix.2
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jan 2017 11:12:59 -0800 (PST)
In-Reply-To: <1030906614.13148012.1483722413675.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: Doug Ledford <dledford@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Zhu Lingshan <lszhu@suse.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>

Laurence,

Since the summary may be helpful to others, I'm just going to send it
to the list.

I've been able to reproduce the D state problem on both Infiniband and
RoCE, but it is much easier to reproduce on RoCE due to another bug
and doesn't require being at the server to yank the cable (remote
power control of a switch may work as well). The bug seems to be
triggered by an abrupt and unexpected break in communications

Common config between both Infiniband and RoCE:
====
* Linux kernel 4.9 (using only inbox drivers, no OFED)
* Target and initiator both configured on the same subnet
* 100 GB ram disk exported by iser [1]
* Iser volume imported on client and the whole block device formatted ext4.
* FIO run on iser volume on the client [2]
* Anything not mentioned in this document should be default (it is a
pretty simple config)

Infiniband specific config:
====
* Any IB cards should work (my config has ConnectX-3, but has also
been seen on Connect-IB in our environment)
* Back to back (my config) or connected to a switch
* OpenSM running on the target (my config), or on a separate host (not
sure how cutting power to the switch may impact triggering the bug, I
believe it will still trigger ok)
* While running the fio job, pull the cable on the initiator side.
After about 120 seconds the fio job will fail and the iscsi processes
should be in D state on the target.

RoCE specific config:
====
* Only tested with ConnectX-4-LX cards (I don't know if others will
trigger the problem, pulling the cable like in the Infiniband section,
may also trigger the bug if it doesn't trigger automatically)
* Hosts must be connected by a switch or a Linux bridge that doesn't
have RoCE offload. I was able to trigger the bugs with a back to back
connection if the target clamps the speed to 10 Gb [3].
* Running the fio job should be enough to trigger the RoCE card to
unexpectedly drop the RDMA connection and that should then cause the
target iscsci processes to go into D state.

For either the Infiniband or RoCE setup, the bug can be triggered with
only two hosts connected back to back. If something is still not
clear, please let me know.

[1] /etc/saveconfig.json
```json
{
  "fabric_modules": [],
  "storage_objects": [
    {
      "attributes": {
        "block_size": 512,
        "emulate_3pc": 1,
        "emulate_caw": 1,
        "emulate_dpo": 0,
        "emulate_fua_read": 0,
        "emulate_fua_write": 1,
        "emulate_model_alias": 1,
        "emulate_rest_reord": 0,
        "emulate_tas": 1,
        "emulate_tpu": 0,
        "emulate_tpws": 0,
        "emulate_ua_intlck_ctrl": 0,
        "emulate_write_cache": 0,
        "enforce_pr_isids": 1,
        "force_pr_aptpl": 0,
        "is_nonrot": 1,
        "max_unmap_block_desc_count": 0,
        "max_unmap_lba_count": 0,
        "max_write_same_len": 0,
        "optimal_sectors": 4294967288,
        "pi_prot_format": 0,
        "pi_prot_type": 0,
        "queue_depth": 128,
        "unmap_granularity": 0,
        "unmap_granularity_alignment": 0
      },
      "name": "test1",
      "plugin": "ramdisk",
      "size": 107374182400,
      "wwn": "7486ed41-585e-400f-8799-ac605485b221"
    }
  ],
  "targets": [
    {
      "fabric": "iscsi",
      "tpgs": [
        {
          "attributes": {
            "authentication": 0,
            "cache_dynamic_acls": 1,
            "default_cmdsn_depth": 64,
            "default_erl": 0,
            "demo_mode_discovery": 1,
            "demo_mode_write_protect": 0,
            "generate_node_acls": 1,
            "login_timeout": 15,
            "netif_timeout": 2,
            "prod_mode_write_protect": 0,
            "t10_pi": 0
          },
          "enable": true,
          "luns": [
            {
              "index": 0,
              "storage_object": "/backstores/ramdisk/test1"
            }
          ],
          "node_acls": [],
          "parameters": {
            "AuthMethod": "CHAP,None",
            "DataDigest": "CRC32C,None",
            "DataPDUInOrder": "Yes",
            "DataSequenceInOrder": "Yes",
            "DefaultTime2Retain": "20",
            "DefaultTime2Wait": "2",
            "ErrorRecoveryLevel": "0",
            "FirstBurstLength": "65536",
            "HeaderDigest": "CRC32C,None",
            "IFMarkInt": "Reject",
            "IFMarker": "No",
            "ImmediateData": "Yes",
            "InitialR2T": "Yes",
            "MaxBurstLength": "262144",
            "MaxConnections": "1",
            "MaxOutstandingR2T": "1",
            "MaxRecvDataSegmentLength": "8192",
            "MaxXmitDataSegmentLength": "262144",
            "OFMarkInt": "Reject",
            "OFMarker": "No",
            "TargetAlias": "LIO Target"
          },
          "portals": [
            {
              "ip_address": "0.0.0.0",
              "iser": true,
              "port": 3260
            }
          ],
          "tag": 1
        }
      ],
      "wwn": "iqn.2016-12.com.betterservers"
    }
  ]
}
```
[2] echo "3" > /proc/sys/vm/drop_caches; fio --rw=read --bs=4K
--size=1G --numjobs=40 --name=worker.matt --group_reporting
[3] ethtool -s eth3 speed 10000 advertise 0x80000
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
