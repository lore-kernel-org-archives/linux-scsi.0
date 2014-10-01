From: Luigi Tarenga <luigi.tarenga@gmail.com>
Subject: Re: targetcli do not show iscsi
Date: Wed, 01 Oct 2014 14:35:50 +0200
Message-ID: <542BF526.1010705@gmail.com>
References: <542A6F44.3070802@gmail.com> <542A7037.6050909@netiant.com> <542A722E.5030109@gmail.com> <542A73BE.2080501@netiant.com> <542A75F1.8070706@gmail.com> <542A77D6.4090109@netiant.com> <542A7ADD.3040804@gmail.com> <542A7BC9.2050708@netiant.com> <542ACA6C.104@redhat.com> <542ACDAE.3080307@gmail.com> <542AD1C2.8070105@gmail.com> <542ADF1D.1020003@gmail.com> <542ADFDB.3010300@netiant.com> <542AE206.4000808@gmail.com> <542AE3E2.1080609@netiant.com> <542BE74F.3080102@gmail.com> <542BEA54.50903@netiant.com> <542BF3FA.6010008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:53047 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbaJAMft (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 08:35:49 -0400
In-Reply-To: <542BF3FA.6010008@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jerome Martin <jxm@netiant.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org


On 10/01/2014 02:30 PM, Luigi Tarenga wrote:
>
>>
>> So, again, I would like to reproduce and solve this on CentOS / RHEL.
>> Can you confirm this is version 6.5 with custom-built kernel 3.16.3 ?
>>
>> In any case, thanks for testing, I need that badly :-)
>>
>> Best Regards,
>> -- 
>> Jerome
>
> Hi Jerome,
> I confirm I have a centos 6.5 x86_64 with custom kernel and I'm using 
> python2.7 compiled
> from source too (since this works for targetcli-fb)
>
> I reinstalled everything (from your git repos) with:
> make cleanall
> make release
> cd dist
> tar xvf xxxx.tar.gz
> cd xxxx
> ./setup.py build
> ./setup.py install
>
>
> I left the LIO configured from a the former fb version:
> this was the output with fb:
> # targetcli
> targetcli shell version 2.1.fb37
> Copyright 2011-2013 by Datera, Inc and others.
> For help on commands, type 'help'.
>
> /> ls
> o- / 
> ......................................................................................................................... 
> [...]
>   o- backstores 
> .............................................................................................................. 
> [...]
>   | o- block 
> .................................................................................................. 
> [Storage Objects: 0]
>   | o- fileio 
> ................................................................................................. 
> [Storage Objects: 1]
>   | | o- test1 
> .................................................................. 
> [/root/lun-test1 (10.0MiB) write-back deactivated]
>   | o- pscsi 
> .................................................................................................. 
> [Storage Objects: 0]
>   | o- ramdisk 
> ................................................................................................ 
> [Storage Objects: 0]
>   o- iscsi 
> ............................................................................................................ 
> [Targets: 1]
>   | o- iqn.2003-01.org.linux-iscsi.lizard.x8664:sn.29470994615c 
> .......................................................... [TPGs: 1]
>   |   o- tpg1 
> ............................................................................................... 
> [no-gen-acls, no-auth]
>   |     o- acls 
> .......................................................................................................... 
> [ACLs: 0]
>   |     o- luns 
> .......................................................................................................... 
> [LUNs: 0]
>   |     o- portals 
> .................................................................................................... 
> [Portals: 1]
>   |       o- 0.0.0.0:3260 
> ..................................................................................................... 
> [OK]
>   o- loopback 
> ......................................................................................................... 
> [Targets: 0]
>   o- sbp 
> .............................................................................................................. 
> [Targets: 0]
>   o- vhost 
> ............................................................................................................ 
> [Targets: 0]
> /> exit
> Global pref auto_save_on_exit=true
> Last 10 configs saved in /etc/target/backup.
> Configuration saved to /etc/target/saveconfig.json
>
>
> (between the 2 test I removed the -fb version to avoid mixing libs)
>
> now I had to make some little mod to the init script because it seems 
> to target centos7/rhel7:
> so this is the patch I used for target.init:
> --- target.init    2014-07-31 19:07:30.000000000 +0200
> +++ target.init.custom    2014-10-01 14:17:57.343006241 +0200
> @@ -9,7 +9,7 @@
>  ### END INIT INFO
>
>  # PATH should only include /usr/* if it runs after the mountnfs.sh 
> script
> -PATH=/sbin:/usr/sbin:/bin:/usr/bin
> +#PATH=/sbin:/usr/sbin:/bin:/usr/bin
>  DESC="The Linux SCSI Target"
>  NAME=target
>  DAEMON=/usr/bin/targetcli
> @@ -25,10 +25,24 @@
>  [ -r /etc/default/$NAME ] && . /etc/default/$NAME
>
>  # Load the VERBOSE setting and other rcS variables
> -. /lib/init/vars.sh
> +#. /lib/init/vars.sh
>
>  # Define LSB log_* functions - requires lsb-base (>= 3.2-14)
> -. /lib/lsb/init-functions
> +#. /lib/lsb/init-functions
> +
> +alias python="python2.7"
> +
> +log_failure_msg () {
> +   echo "$@"
> +}
> +
> +log_action_msg () {
> +   echo "$@"
> +}
> +
> +log_warning_msg () {
> +   echo "$@"
> +}
>
>
> and this is the output when I start it:
> # ./target.init.custom start
> Possible config migration detected, saving the  running target to 
> /etc/target/scsi_target.lio
> Traceback (most recent call last):
>   File "<stdin>", line 3, in <module>
>   File "/usr/local/lib/python2.7/site-packages/rtslib/config.py", line 
> 562, in load_live
>     source=source, allow_new_attrs=True)
>   File "/usr/local/lib/python2.7/site-packages/rtslib/config.py", line 
> 190, in _load_parse_tree
>     token = self.validate_obj(token, cur)
>   File "/usr/local/lib/python2.7/site-packages/rtslib/config.py", line 
> 385, in validate_obj
>     raise ConfigError("Unknown object type: %s" % obj_type)
> rtslib.config.ConfigError: Unknown object type: storage
> The Linux SCSI Target looks properly installed
> The configfs filesystem is already mounted
> Core module target_core_mod already loaded
> Failed to load core module target_core_pscsi
> Could not start The Linux SCSI Target
>
>
>
> # targetcli
> targetcli 3.0~pre2-5-g7e32595 (rtslib 3.0~pre2-8-g86e46bc)
> Copyright (c) 2011-2014 by Datera, Inc.
> All rights reserved.
>
> /> ls
> o- / 
> ......................................................................................................................... 
> [...]
>   o- backstores 
> .............................................................................................................. 
> [...]
>     o- fileio 
> ................................................................................................... 
> [1 Storage Object]
>     | o- test1 
> ............................................................................... 
> [/root/lun-test1 (10.0M) deactivated]
>     o- iblock 
> ................................................................................................... 
> [0 Storage Object]
>     o- pscsi 
> .................................................................................................... 
> [0 Storage Object]
>     o- rd_mcp 
> ................................................................................................... 
> [0 Storage Object]
> /> exit
> Traceback (most recent call last):
>   File "/usr/local/lib/python2.7/site-packages/configshell/shell.py", 
> line 990, in run_interactive
>     self._cli_loop()
>   File "/usr/local/lib/python2.7/site-packages/configshell/shell.py", 
> line 820, in _cli_loop
>     self.run_cmdline(cmdline)
>   File "/usr/local/lib/python2.7/site-packages/configshell/shell.py", 
> line 934, in run_cmdline
>     self._execute_command(path, command, pparams, kparams)
>   File "/usr/local/lib/python2.7/site-packages/configshell/shell.py", 
> line 909, in _execute_command
>     result = target.execute_command(command, pparams, kparams)
>   File "/usr/local/lib/python2.7/site-packages/targetcli/ui_node.py", 
> line 103, in execute_command
>     pparams, kparams)
>   File "/usr/local/lib/python2.7/site-packages/configshell/node.py", 
> line 1416, in execute_command
>     result = method(*pparams, **kparams)
>   File "/usr/local/lib/python2.7/site-packages/targetcli/ui_node.py", 
> line 119, in ui_command_exit
>     config.load_live()
>   File "/usr/local/lib/python2.7/site-packages/rtslib/config.py", line 
> 562, in load_live
>     source=source, allow_new_attrs=True)
>   File "/usr/local/lib/python2.7/site-packages/rtslib/config.py", line 
> 190, in _load_parse_tree
>     token = self.validate_obj(token, cur)
>   File "/usr/local/lib/python2.7/site-packages/rtslib/config.py", line 
> 385, in validate_obj
>     raise ConfigError("Unknown object type: %s" % obj_type)
> ConfigError: Unknown object type: storage
>
>
> Luigi
>
> PS: should we keep linux-scsi ML in cc?

I forgot this:
 > version
Using configshell version 1.5-4-g0827baa
Using rtslib version 3.0~pre2-8-g86e46bc
Using targetcli version 3.0~pre2-5-g7e32595

Luigi
