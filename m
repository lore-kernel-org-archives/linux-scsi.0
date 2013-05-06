From: Patrick Monnerat <pm@datasphere.ch>
Subject: Re: [PATCH 1/1] Create megaraid ioctl device node
Date: Mon, 06 May 2013 17:13:47 +0200
Message-ID: <5187C8AB.90501@datasphere.ch>
References: <AB5E58B87EB73C46A38073D8F459F113D9FBA4@dataspheresrv01> <87a9o86vbj.fsf@nemi.mork.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87a9o86vbj.fsf@nemi.mork.no>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/06/2013 04:23 PM, Bj=C3=B8rn Mork wrote:
> "Patrick Monnerat" <Patrick.Monnerat@datasphere.ch> writes:
>>    Create ioctl device node for megaraid_sas driver. Let this node b=
e
>> managed by udev. Fix a typo.
>
> Or maybe just simplify it all and use a misc device instead?  See how
> this is done in e.g. drivers/scsi/mpt3sas/mpt3sas_ctl.c or
> drivers/message/fusion/mptctl.c

Yes, could be done that way, But I want to retain compatibility with=20
existing shell scripts doing things like:

DEVICE=3D/dev/megaraid_sas_ioctl_node
DEVICENAME=3Dmegaraid_sas_ioctl
DEVICEPERM=3D400
MAJOR=3D`grep "$DEVICENAME" /proc/devices | awk '{print $1}'`

if [ -n "$MAJOR" -a ! -e "$DEVICE" ]; then
     mknod "$DEVICE" c "$MAJOR" 0
     chmod "$DEVICEPERM" "$DEVICE"
fi

Snippets like this one appear both in open-source projects and Dell scr=
ipts.

Patrick
