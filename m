From: James.Smart@Emulex.Com
Subject: [Patch] [Repost] Add FC transport host statistics
Date: Tue, 30 Nov 2004 23:45:02 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C12E7DD@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:39840 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261227AbULAEpf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 23:45:35 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, MPESCHKE@de.ibm.com, schwidefsky@de.ibm.com, akpm@osdl.org

This patch has been updated so that it backs against scsi-misc-2.6 as of 2004/11/27. This patch depends on the previous patch:
  "[Patch] [Repost] Add basic infrastructure for transport host statistics".

-- James S

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Smart, James
> Sent: Thursday, October 14, 2004 10:49 AM
> To: linux-scsi@vger.kernel.org
> Cc: andrew.vasquez@qlogic.com; michaelc@cs.wisc.edu
> Subject: [Patch RFC] Add FC transport host statistics
> 
> 
> 
> This patch updates the fc_transport with statistics for local FC ports
> (e.g. Hosts).  The statistics are defined per HBAAPI v2.0 definitions.
> 
> Caveats:
> ------------
> - This patch applies to the scsi-target-2.6 bitkeeper tree. 
> It is dependent
>   upon the previous "host statistics" patch.
> 
> - The information below is supplied by a simple test driver 
> that does not
>   talk to real hardware, but fully acts as a LLDD that supports the
>   fc transport.
> 
> 
> This patch results in the following in /sys/class:
> -----------------------------------------------------
> 
> [jsmart@elxware class]$ cd /sys/class
> [jsmart@elxware class]$ ls
> fc_host       graphics  misc     pci_bus       scsi_host  usb_host
> fc_transport  input     net      scsi_device   tty        vc
> firmware      mem       netlink  scsi_generic  usb
> [jsmart@elxware class]$ cd fc_host
> [jsmart@elxware fc_host]$ ls
> host4
> 
> [jsmart@elxware fc_host]$ cd host4
> [jsmart@elxware host4]$ ls
> device                 host_link_down_tmo           statistics
> [jsmart@elxware host4]$ ls -ld *
> lrwxrwxrwx  1 root root    0 Oct 13 17:16 device -> 
> ../../../devices/platform/host4
> -rw-r--r--  1 root root 4096 Oct 13 17:16 host_link_down_tmo
> drwxr-xr-x  2 root root    0 Oct 13 17:16 statistics
> 
> [jsmart@elxware host4]$ cd statistics
> dumped_frames         invalid_crc_count      
> prim_seq_protocol_err_count
> error_frames          invalid_tx_word_count  reset_statistics
> fcp_control_requests  link_failure_count     rx_frames
> fcp_input_megabytes   lip_count              rx_words
> fcp_input_requests    loss_of_signal_count   seconds_since_last_reset
> fcp_output_megabytes  loss_of_sync_count     tx_frames
> fcp_output_requests   nos_count              tx_words
> 
> [jsmart@elxware statistics]$ ls -ld *
> -r--r--r--  1 root root 4096 Oct 13 17:16 dumped_frames
> -r--r--r--  1 root root 4096 Oct 13 17:16 error_frames
> -r--r--r--  1 root root 4096 Oct 13 17:16 fcp_control_requests
> -r--r--r--  1 root root 4096 Oct 13 17:16 fcp_input_megabytes
> -r--r--r--  1 root root 4096 Oct 13 17:16 fcp_input_requests
> -r--r--r--  1 root root 4096 Oct 13 17:16 fcp_output_megabytes
> -r--r--r--  1 root root 4096 Oct 13 17:16 fcp_output_requests
> -r--r--r--  1 root root 4096 Oct 13 17:16 invalid_crc_count
> -r--r--r--  1 root root 4096 Oct 13 17:16 invalid_tx_word_count
> -r--r--r--  1 root root 4096 Oct 13 17:16 link_failure_count
> -r--r--r--  1 root root 4096 Oct 13 17:16 lip_count
> -r--r--r--  1 root root 4096 Oct 13 17:16 loss_of_signal_count
> -r--r--r--  1 root root 4096 Oct 13 17:16 loss_of_sync_count
> -r--r--r--  1 root root 4096 Oct 13 17:16 nos_count
> -r--r--r--  1 root root 4096 Oct 13 17:16 prim_seq_protocol_err_count
> --w-------  1 root root 4096 Oct 13 17:16 reset_statistics
> -r--r--r--  1 root root 4096 Oct 13 17:16 rx_frames
> -r--r--r--  1 root root 4096 Oct 13 17:16 rx_words
> -r--r--r--  1 root root 4096 Oct 13 17:16 seconds_since_last_reset
> -r--r--r--  1 root root 4096 Oct 13 17:16 tx_frames
> -r--r--r--  1 root root 4096 Oct 13 17:16 tx_words
> 
> 
> Using the following script (/tmp/show_attributes):
>     #!/bin/sh
>     FILES=`ls *`
>     for file in $FILES; do
>       if [ -f $file ] ; then
>         echo "$file : " `cat $file`
>       fi
>     done
> 
> Here's a sample of querying the statistics:
> 
> [jsmart@elxware /]$ cd /sys/class/fc_host/host4/statistics
> [jsmart@elxware statistics]$ /tmp/li
> dumped_frames :  0x8
> error_frames :  0x7
> fcp_control_requests :  0x11
> fcp_input_megabytes :  0x12
> fcp_input_requests :  0xf
> fcp_output_megabytes :  0x13
> fcp_output_requests :  0x10
> invalid_crc_count :  0xe
> invalid_tx_word_count :  0xd
> link_failure_count :  0x9
> lip_count :  0x5
> loss_of_signal_count :  0xb
> loss_of_sync_count :  0xa
> nos_count :  0x6
> prim_seq_protocol_err_count :  0xc
> cat: reset_statistics: Permission denied
> reset_statistics : 
> rx_frames :  0x3
> rx_words :  0x4
> seconds_since_last_reset :  0x0
> tx_frames :  0x1
> tx_words :  0x2
> 
> 
> 
