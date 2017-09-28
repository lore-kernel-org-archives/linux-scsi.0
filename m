From: "Tangchen (UVP)" <tang.chen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [iscsiadm] iscsiadm creates multiple same sessions when run with
 --login option in parallel.
Date: Thu, 28 Sep 2017 06:42:48 +0000
Message-ID: <22E823DBB7698E489DC113638F7470729F082E@DGGEMM506-MBS.china.huawei.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBD7NBF4S7MOBB45TWLHAKGQE6ZTV7JI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Language: zh-CN
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: "open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Zhangyanfei (YF)" <yanfei.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, guijianfeng <guijianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Tangchen
 (UVP)" <tang.chen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi guys,

If we run iscsiadm -m node --login command through the same IP address 4 times, only one session will be created.
But if we run them in parallel, then 4 same sessions could be created.
( Here, xxx.xxx.xxx.xxx is the IP address to the IPSAN. I'm using the same IP in these 4 commands. )

# iscsiadm -m node -p xxx.xxx.xxx.xxx  --login &
# iscsiadm -m node -p xxx.xxx.xxx.xxx  --login &
# iscsiadm -m node -p xxx.xxx.xxx.xxx  --login &
# iscsiadm -m node -p xxx.xxx.xxx.xxx  --login &
Logging in to [iface: default, target: iqn. xxx.xxx.xxx.xxx, portal: xxx.xxx.xxx.xxx] (multiple)
Logging in to [iface: default, target: iqn. xxx.xxx.xxx.xxx, portal: xxx.xxx.xxx.xxx] (multiple)
Logging in to [iface: default, target: iqn. xxx.xxx.xxx.xxx, portal: xxx.xxx.xxx.xxx] (multiple)
Logging in to [iface: default, target: iqn. xxx.xxx.xxx.xxx, portal: xxx.xxx.xxx.xxx] (multiple)
Login to [iface: default, target: xxx.xxx.xxx.xxx, portal: xxx.xxx.xxx.xxx] successful.
Login to [iface: default, target: xxx.xxx.xxx.xxx, portal: xxx.xxx.xxx.xxx] successful.
Login to [iface: default, target: xxx.xxx.xxx.xxx, portal: xxx.xxx.xxx.xxx] successful.
Login to [iface: default, target: xxx.xxx.xxx.xxx, portal: xxx.xxx.xxx.xxx] successful.

# iscsiadm -m session
tcp: [1] xxx.xxx.xxx.xxx (non-flash)
tcp: [2] xxx.xxx.xxx.xxx (non-flash)
tcp: [3] xxx.xxx.xxx.xxx (non-flash)
tcp: [4] xxx.xxx.xxx.xxx (non-flash)

If we check the net connection in /proc/net/nf_conntrack, they are 4 TCP connections with different src ports.
And if we run logout command only once, all the 4 sessions will be destroyed.

Unfortunately, service like multipathd cannot tell the difference between them. If we have 4 same sessions, 
4 paths will be created connecting to the dm device. But actually they are the same paths.

Referring to the code, iscsiadm command does prevent creating same session by checking /sys/class/iscsi_session/ dir.
But no multi-thread protection in there. 

Any idea how to solve this problem ?

Thanks.

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
