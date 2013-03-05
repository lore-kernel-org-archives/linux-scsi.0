From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: qla2xxx: issues when creating a new target port
Date: Tue, 05 Mar 2013 13:52:55 -0800
Message-ID: <1362520375.7905.166.camel@haakon2.linux-iscsi.org>
References: <B1C4F02B-5252-49BC-9FF9-7FB0A74872D8@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58066 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3CEVw5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Mar 2013 16:52:57 -0500
In-Reply-To: <B1C4F02B-5252-49BC-9FF9-7FB0A74872D8@bootc.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Boot <bootc@bootc.net>
Cc: andrew.vasquez@qlogic.com, linux-driver@qlogic.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>

Hi Chris,

On Sun, 2013-03-03 at 13:49 +0000, Chris Boot wrote:
> Hi all,
> 
> When creating a new target port in targetcli (/qla2xxx create
> 21:0x:...), and I have nothing plugged-in to the port, the creation
> process takes quite some time. After a few seconds, the kernel prints
> a message saying "Cable is unplugged...". So far so good.
> 

AFAIK the delay is expected here when no physical link is detected.

> It seems that when the target is created, it comes up in the 'enabled'
> state, regardless of me having set 'auto_enable_tpgt=false'. Running
> 'disable' from targetcli seems to try to bring the link up again
> ("Performing ISP error recovery" then "Cable is unplugged...") and the
> target remains in the enabled state.
> 

Running 'disable' from targetcli will perform:

  echo 0 > /sys/kernel/config/target/qla2xxx/$FC_WWPN/$TPGT/enable

that will effectively disable target mode on the $FC_WWPN port in
question, regardless of what else (LUNs, ACLs) are configured.

Target mode is only re-enabled at the HW level for the port with:

  echo 1 > /sys/kernel/config/target/qla2xxx/$FC_WWPN/$TPGT/enable


> If I then add LUNs and ACLs to the target, everything appears OK, but
> plugging the target port into an initiator gives odd behaviour. The
> initiator spends a very long time scanning the target and eventually
> times out and finds no LUNs. The only way to get the port working
> again is to save the configuration and reboot the target server, which
> is very frustrating.
> 

Can you double check the value of ../qla2xxx/$FC_WWPN/$TPGT/enable when
this happens..?  From the description above it sounds like your
explicitly disabling target mode on the port.

> I'm using targetcli as found in Debian wheezy with kernel 3.8.0,
> though I have had this problem for a little while now...
> 

For reference, can you provide the HBAs that your reproducing with..?

Also, a target side log with

   modprobe qla2xxx ql2xextended_error_logging=0x7fffffff

would be helpful as well.

Thanks,

--nab

