From: Fred Herard <fred.herard-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] iscsi: Capture iscsi debug messages using tracepoints
Date: Sun, 2 Dec 2018 01:47:09 -0500
Message-ID: <1325e1ee-f690-f6c8-c2a8-fdf26f3c0c51@oracle.com>
References: <1542819883-15685-1-git-send-email-fred.herard@oracle.com>
 <65d1a89a-da7c-892b-7231-69c509333811@suse.com>
 <edb2cb72-df44-0549-eab1-c2848a328887@interlog.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBCHYH6ECSQDBB4H7RXQAKGQESUL3VEQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <edb2cb72-df44-0549-eab1-c2848a328887-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org, Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Doug,

Here's an updated patch with removal of the misplaced semicolons:

>From da1f3c2ff78881c439d53820f3b82d4c54ac5cf9 Mon Sep 17 00:00:00 2001
From: Fred Herard <fred.herard-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date: Fri, 12 Oct 2018 15:45:47 -0700
Subject: [PATCH] iscsi: Capture iscsi debug messages using tracepoints

This commit enhances iscsi initiator modules to capture iscsi debug messages
using linux kernel tracepoint facility:

https://www.kernel.org/doc/Documentation/trace/tracepoints.txt

The following tracepoint events have been created under the iscsi tracepoint
event group:

iscsi_dbg_conn - to capture connection debug messages (libiscsi module)
iscsi_dbg_session - to capture session debug messages (libiscsi module)
iscsi_dbg_eh - to capture error handling debug messages (libiscsi module)
iscsi_dbg_tcp - to capture iscsi tcp debug messages (libiscsi_tcp module)
iscsi_dbg_sw_tcp - to capture iscsi sw tcp debug messages (iscsi_tcp module)
iscsi_dbg_trans_session - to cpature iscsi trasnsport sess debug messages
	(scsi_transport_iscsi module)
iscsi_dbg_trans_conn - to capture iscsi tansport conn debug messages
	(scsi_transport_iscsi module)

Signed-off-by: Fred Herard <fred.herard-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Rajan Shanmugavelu <rajan.shanmugavelu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/iscsi_tcp.c            |   6 +-
 drivers/scsi/libiscsi.c             |  16 +++++-
 drivers/scsi/libiscsi_tcp.c         |   6 +-
 drivers/scsi/scsi_transport_iscsi.c |  38 ++++++++++++-
 include/trace/events/iscsi.h        | 107 ++++++++++++++++++++++++++++++++++++
 5 files changed, 165 insertions(+), 8 deletions(-)
 create mode 100644 include/trace/events/iscsi.h

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index e11eff6..33bfb0a 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -44,6 +44,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_transport_iscsi.h>
+#include <trace/events/iscsi.h>
 
 #include "iscsi_tcp.h"
 
@@ -72,7 +73,10 @@
 			iscsi_conn_printk(KERN_INFO, _conn,	\
 					     "%s " dbg_fmt,	\
 					     __func__, ##arg);	\
-	} while (0);
+		iscsi_dbg_trace(trace_iscsi_dbg_sw_tcp,		\
+				&(_conn)->cls_conn->dev,	\
+				"%s " dbg_fmt, __func__, ##arg);\
+	} while (0)
 
 
 /**
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index cf8a15e..3a7e3e7 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -40,6 +40,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/libiscsi.h>
+#include <trace/events/iscsi.h>
 
 static int iscsi_dbg_lib_conn;
 module_param_named(debug_libiscsi_conn, iscsi_dbg_lib_conn, int,
@@ -68,7 +69,10 @@
 			iscsi_conn_printk(KERN_INFO, _conn,	\
 					     "%s " dbg_fmt,	\
 					     __func__, ##arg);	\
-	} while (0);
+		iscsi_dbg_trace(trace_iscsi_dbg_conn,		\
+				&(_conn)->cls_conn->dev,	\
+				"%s " dbg_fmt, __func__, ##arg);\
+	} while (0)
 
 #define ISCSI_DBG_SESSION(_session, dbg_fmt, arg...)			\
 	do {								\
@@ -76,7 +80,10 @@
 			iscsi_session_printk(KERN_INFO, _session,	\
 					     "%s " dbg_fmt,		\
 					     __func__, ##arg);		\
-	} while (0);
+		iscsi_dbg_trace(trace_iscsi_dbg_session, 		\
+				&(_session)->cls_session->dev,		\
+				"%s " dbg_fmt, __func__, ##arg);	\
+	} while (0)
 
 #define ISCSI_DBG_EH(_session, dbg_fmt, arg...)				\
 	do {								\
@@ -84,7 +91,10 @@
 			iscsi_session_printk(KERN_INFO, _session,	\
 					     "%s " dbg_fmt,		\
 					     __func__, ##arg);		\
-	} while (0);
+		iscsi_dbg_trace(trace_iscsi_dbg_eh,			\
+				&(_session)->cls_session->dev,		\
+				"%s " dbg_fmt, __func__, ##arg);	\
+	} while (0)
 
 inline void iscsi_conn_queue_work(struct iscsi_conn *conn)
 {
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 63a1d69..75426b1 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -43,6 +43,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_transport_iscsi.h>
+#include <trace/events/iscsi.h>
 
 #include "iscsi_tcp.h"
 
@@ -65,7 +66,10 @@
 			iscsi_conn_printk(KERN_INFO, _conn,	\
 					     "%s " dbg_fmt,	\
 					     __func__, ##arg);	\
-	} while (0);
+		iscsi_dbg_trace(trace_iscsi_dbg_tcp,		\
+				&(_conn)->cls_conn->dev,	\
+				"%s " dbg_fmt, __func__, ##arg);\
+	} while (0)
 
 static int iscsi_tcp_hdr_recv_done(struct iscsi_tcp_conn *tcp_conn,
 				   struct iscsi_segment *segment);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f6542c1..b370f7b 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -37,6 +37,18 @@
 
 #define ISCSI_TRANSPORT_VERSION "2.0-870"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/iscsi.h>
+
+/*
+ * Export tracepoint symbols to be used by other modules.
+ */
+EXPORT_TRACEPOINT_SYMBOL_GPL(iscsi_dbg_conn);
+EXPORT_TRACEPOINT_SYMBOL_GPL(iscsi_dbg_eh);
+EXPORT_TRACEPOINT_SYMBOL_GPL(iscsi_dbg_session);
+EXPORT_TRACEPOINT_SYMBOL_GPL(iscsi_dbg_tcp);
+EXPORT_TRACEPOINT_SYMBOL_GPL(iscsi_dbg_sw_tcp);
+
 static int dbg_session;
 module_param_named(debug_session, dbg_session, int,
 		   S_IRUGO | S_IWUSR);
@@ -59,15 +71,21 @@
 			iscsi_cls_session_printk(KERN_INFO, _session,	\
 						 "%s: " dbg_fmt,	\
 						 __func__, ##arg);	\
-	} while (0);
+		iscsi_dbg_trace(trace_iscsi_dbg_trans_session,		\
+				&(_session)->dev,			\
+				"%s " dbg_fmt, __func__, ##arg);	\
+	} while (0)
 
 #define ISCSI_DBG_TRANS_CONN(_conn, dbg_fmt, arg...)			\
 	do {								\
 		if (dbg_conn)						\
 			iscsi_cls_conn_printk(KERN_INFO, _conn,		\
 					      "%s: " dbg_fmt,		\
-					      __func__, ##arg);	\
-	} while (0);
+					      __func__, ##arg);		\
+		iscsi_dbg_trace(trace_iscsi_dbg_trans_conn,		\
+				&(_conn)->dev,				\
+				"%s " dbg_fmt, __func__, ##arg);	\
+	} while (0)
 
 struct iscsi_internal {
 	struct scsi_transport_template t;
@@ -4497,6 +4515,20 @@ int iscsi_unregister_transport(struct iscsi_transport *tt)
 }
 EXPORT_SYMBOL_GPL(iscsi_unregister_transport);
 
+void iscsi_dbg_trace(void (*trace)(struct device *dev, struct va_format *),
+		     struct device *dev, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	trace(dev, &vaf);
+	va_end(args);
+}
+EXPORT_SYMBOL_GPL(iscsi_dbg_trace);
+
 static __init int iscsi_transport_init(void)
 {
 	int err;
diff --git a/include/trace/events/iscsi.h b/include/trace/events/iscsi.h
new file mode 100644
index 0000000..87408fa
--- /dev/null
+++ b/include/trace/events/iscsi.h
@@ -0,0 +1,107 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM iscsi
+
+#if !defined(_TRACE_ISCSI_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_ISCSI_H
+
+#include <linux/tracepoint.h>
+
+/* max debug message length */
+#define ISCSI_MSG_MAX	256
+
+/*
+ * Declare tracepoint helper function.
+ */
+void iscsi_dbg_trace(void (*trace)(struct device *dev, struct va_format *),
+		     struct device *dev, const char *fmt, ...);
+
+/*
+ * Declare event class for iscsi debug messages.
+ */
+DECLARE_EVENT_CLASS(iscsi_log_msg,
+
+	TP_PROTO(struct device *dev, struct va_format *vaf),
+
+	TP_ARGS(dev, vaf),
+
+	TP_STRUCT__entry(
+		__string(dname, 	dev_name(dev)		)
+		__dynamic_array(char,	msg, ISCSI_MSG_MAX	)
+	),
+
+	TP_fast_assign(
+		__assign_str(dname, dev_name(dev));
+		vsnprintf(__get_str(msg), ISCSI_MSG_MAX, vaf->fmt, *vaf->va);
+	),
+
+	TP_printk("%s: %s",__get_str(dname),  __get_str(msg)
+	)
+);
+
+/*
+ * Define event to capture iscsi connection debug messages.
+ */
+DEFINE_EVENT(iscsi_log_msg, iscsi_dbg_conn,
+	TP_PROTO(struct device *dev, struct va_format *vaf),
+
+	TP_ARGS(dev, vaf)
+);
+
+/*
+ * Define event to capture iscsi session debug messages.
+ */
+DEFINE_EVENT(iscsi_log_msg, iscsi_dbg_session,
+	TP_PROTO(struct device *dev, struct va_format *vaf),
+
+	TP_ARGS(dev, vaf)
+);
+
+/*
+ * Define event to capture iscsi error handling debug messages.
+ */
+DEFINE_EVENT(iscsi_log_msg, iscsi_dbg_eh,
+        TP_PROTO(struct device *dev, struct va_format *vaf),
+
+        TP_ARGS(dev, vaf)
+);
+
+/*
+ * Define event to capture iscsi tcp debug messages.
+ */
+DEFINE_EVENT(iscsi_log_msg, iscsi_dbg_tcp,
+        TP_PROTO(struct device *dev, struct va_format *vaf),
+
+        TP_ARGS(dev, vaf)
+);
+
+/*
+ * Define event to capture iscsi sw tcp debug messages.
+ */
+DEFINE_EVENT(iscsi_log_msg, iscsi_dbg_sw_tcp,
+	TP_PROTO(struct device *dev, struct va_format *vaf),
+
+	TP_ARGS(dev, vaf)
+);
+
+/*
+ * Define event to capture iscsi transport session debug messages.
+ */
+DEFINE_EVENT(iscsi_log_msg, iscsi_dbg_trans_session,
+	TP_PROTO(struct device *dev, struct va_format *vaf),
+
+	TP_ARGS(dev, vaf)
+);
+
+/*
+ * Define event to capture iscsi transport connection debug messages.
+ */
+DEFINE_EVENT(iscsi_log_msg, iscsi_dbg_trans_conn,
+	TP_PROTO(struct device *dev, struct va_format *vaf),
+
+	TP_ARGS(dev, vaf)
+);
+
+#endif /* _TRACE_ISCSI_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.8.3.1

-Fred

On 12/1/2018 12:46 AM, Douglas Gilbert wrote:
> Hi,
> Misplaced semi-colons below.
> 
> On 2018-11-26 8:01 p.m., Lee Duncan wrote:
>> On 11/21/18 9:04 AM, fred.herard-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org wrote:
>>> From: Fred Herard <fred.herard-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>>
>>> This commit enhances iscsi initiator modules to capture iscsi debug messages
>>> using linux kernel tracepoint facility:
>>>
>>> https://www.kernel.org/doc/Documentation/trace/tracepoints.txt
>>>
>>> The following tracepoint events have been created under the iscsi tracepoint
>>> event group:
>>>
>>> iscsi_dbg_conn - to capture connection debug messages (libiscsi module)
>>> iscsi_dbg_session - to capture session debug messages (libiscsi module)
>>> iscsi_dbg_eh - to capture error handling debug messages (libiscsi module)
>>> iscsi_dbg_tcp - to capture iscsi tcp debug messages (libiscsi_tcp module)
>>> iscsi_dbg_sw_tcp - to capture iscsi sw tcp debug messages (iscsi_tcp module)
>>> iscsi_dbg_trans_session - to cpature iscsi trasnsport sess debug messages
>>>     (scsi_transport_iscsi module)
>>> iscsi_dbg_trans_conn - to capture iscsi tansport conn debug messages
>>>     (scsi_transport_iscsi module)
>>>
>>> Signed-off-by: Fred Herard <fred.herard-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> Reviewed-by: Rajan Shanmugavelu <rajan.shanmugavelu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>   drivers/scsi/iscsi_tcp.c            |   4 ++
>>>   drivers/scsi/libiscsi.c             |  10 +++
>>>   drivers/scsi/libiscsi_tcp.c         |   4 ++
>>>   drivers/scsi/scsi_transport_iscsi.c |  34 ++++++++-
>>>   include/trace/events/iscsi.h        | 107 ++++++++++++++++++++++++++++
>>>   5 files changed, 158 insertions(+), 1 deletion(-)
>>>   create mode 100644 include/trace/events/iscsi.h
>>>
>>> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
>>> index e11eff6b0e97..cf6475af72b1 100644
>>> --- a/drivers/scsi/iscsi_tcp.c
>>> +++ b/drivers/scsi/iscsi_tcp.c
>>> @@ -44,6 +44,7 @@
>>>   #include <scsi/scsi_host.h>
>>>   #include <scsi/scsi.h>
>>>   #include <scsi/scsi_transport_iscsi.h>
>>> +#include <trace/events/iscsi.h>
>>>     #include "iscsi_tcp.h"
>>>   @@ -72,6 +73,9 @@ MODULE_PARM_DESC(debug_iscsi_tcp, "Turn on debugging for iscsi_tcp module "
>>>               iscsi_conn_printk(KERN_INFO, _conn,    \
>>>                            "%s " dbg_fmt,    \
>>>                            __func__, ##arg);    \
>>> +        iscsi_dbg_trace(trace_iscsi_dbg_sw_tcp,        \
>>> +                &(_conn)->cls_conn->dev,    \
>>> +                "%s " dbg_fmt, __func__, ##arg);\
>>>       } while (0);
> 
> I was just looking through the code (to possibly copy it) and noticed
> that semi-colon after "while (0)". I'm pretty sure that it shouldn't
> be there.
> 
> include/linux$ grep "while (0)" *.h | wc
>     391    2361   18267
> include/linux$ grep "while (0);" *.h | wc
>       6      29     161
> 
> Dito every other macro definition.
> 
> Doug Gilbert
> 
>>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>>> index cf8a15e54d83..088e90308c1f 100644
>>> --- a/drivers/scsi/libiscsi.c
>>> +++ b/drivers/scsi/libiscsi.c
>>> @@ -40,6 +40,7 @@
>>>   #include <scsi/scsi_transport.h>
>>>   #include <scsi/scsi_transport_iscsi.h>
>>>   #include <scsi/libiscsi.h>
>>> +#include <trace/events/iscsi.h>
>>>     static int iscsi_dbg_lib_conn;
>>>   module_param_named(debug_libiscsi_conn, iscsi_dbg_lib_conn, int,
>>> @@ -68,6 +69,9 @@ MODULE_PARM_DESC(debug_libiscsi_eh,
>>>               iscsi_conn_printk(KERN_INFO, _conn,    \
>>>                            "%s " dbg_fmt,    \
>>>                            __func__, ##arg);    \
>>> +        iscsi_dbg_trace(trace_iscsi_dbg_conn,        \
>>> +                &(_conn)->cls_conn->dev,    \
>>> +                "%s " dbg_fmt, __func__, ##arg);\
>>>       } while (0);
>>>     #define ISCSI_DBG_SESSION(_session, dbg_fmt, arg...)            \
>>> @@ -76,6 +80,9 @@ MODULE_PARM_DESC(debug_libiscsi_eh,
>>>               iscsi_session_printk(KERN_INFO, _session,    \
>>>                            "%s " dbg_fmt,        \
>>>                            __func__, ##arg);        \
>>> +        iscsi_dbg_trace(trace_iscsi_dbg_session,         \
>>> +                &(_session)->cls_session->dev,        \
>>> +                "%s " dbg_fmt, __func__, ##arg);    \
>>>       } while (0);
>>>     #define ISCSI_DBG_EH(_session, dbg_fmt, arg...)                \
>>> @@ -84,6 +91,9 @@ MODULE_PARM_DESC(debug_libiscsi_eh,
>>>               iscsi_session_printk(KERN_INFO, _session,    \
>>>                            "%s " dbg_fmt,        \
>>>                            __func__, ##arg);        \
>>> +        iscsi_dbg_trace(trace_iscsi_dbg_eh,            \
>>> +                &(_session)->cls_session->dev,        \
>>> +                "%s " dbg_fmt, __func__, ##arg);    \
>>>       } while (0);
>>>     inline void iscsi_conn_queue_work(struct iscsi_conn *conn)
>>> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
>>> index 63a1d69ff515..d641a72ae033 100644
>>> --- a/drivers/scsi/libiscsi_tcp.c
>>> +++ b/drivers/scsi/libiscsi_tcp.c
>>> @@ -43,6 +43,7 @@
>>>   #include <scsi/scsi_host.h>
>>>   #include <scsi/scsi.h>
>>>   #include <scsi/scsi_transport_iscsi.h>
>>> +#include <trace/events/iscsi.h>
>>>     #include "iscsi_tcp.h"
>>>   @@ -65,6 +66,9 @@ MODULE_PARM_DESC(debug_libiscsi_tcp, "Turn on debugging for libiscsi_tcp "
>>>               iscsi_conn_printk(KERN_INFO, _conn,    \
>>>                            "%s " dbg_fmt,    \
>>>                            __func__, ##arg);    \
>>> +        iscsi_dbg_trace(trace_iscsi_dbg_tcp,        \
>>> +                &(_conn)->cls_conn->dev,    \
>>> +                "%s " dbg_fmt, __func__, ##arg);\
>>>       } while (0);
>>>     static int iscsi_tcp_hdr_recv_done(struct iscsi_tcp_conn *tcp_conn,
>>> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
>>> index f6542c159ed6..58e0310ce258 100644
>>> --- a/drivers/scsi/scsi_transport_iscsi.c
>>> +++ b/drivers/scsi/scsi_transport_iscsi.c
>>> @@ -37,6 +37,18 @@
>>>     #define ISCSI_TRANSPORT_VERSION "2.0-870"
>>>   +#define CREATE_TRACE_POINTS
>>> +#include <trace/events/iscsi.h>
>>> +
>>> +/*
>>> + * Export tracepoint symbols to be used by other modules.
>>> + */
>>> +EXPORT_TRACEPOINT_SYMBOL_GPL(iscsi_dbg_conn);
>>> +EXPORT_TRACEPOINT_SYMBOL_GPL(iscsi_dbg_eh);
>>> +EXPORT_TRACEPOINT_SYMBOL_GPL(iscsi_dbg_session);
>>> +EXPORT_TRACEPOINT_SYMBOL_GPL(iscsi_dbg_tcp);
>>> +EXPORT_TRACEPOINT_SYMBOL_GPL(iscsi_dbg_sw_tcp);
>>> +
>>>   static int dbg_session;
>>>   module_param_named(debug_session, dbg_session, int,
>>>              S_IRUGO | S_IWUSR);
>>> @@ -59,6 +71,9 @@ MODULE_PARM_DESC(debug_conn,
>>>               iscsi_cls_session_printk(KERN_INFO, _session,    \
>>>                            "%s: " dbg_fmt,    \
>>>                            __func__, ##arg);    \
>>> +        iscsi_dbg_trace(trace_iscsi_dbg_trans_session,        \
>>> +                &(_session)->dev,            \
>>> +                "%s " dbg_fmt, __func__, ##arg);    \
>>>       } while (0);
>>>     #define ISCSI_DBG_TRANS_CONN(_conn, dbg_fmt, arg...)            \
>>> @@ -66,7 +81,10 @@ MODULE_PARM_DESC(debug_conn,
>>>           if (dbg_conn)                        \
>>>               iscsi_cls_conn_printk(KERN_INFO, _conn,        \
>>>                             "%s: " dbg_fmt,        \
>>> -                          __func__, ##arg);    \
>>> +                          __func__, ##arg);        \
>>> +        iscsi_dbg_trace(trace_iscsi_dbg_trans_conn,        \
>>> +                &(_conn)->dev,                \
>>> +                "%s " dbg_fmt, __func__, ##arg);    \
>>>       } while (0);
>>>     struct iscsi_internal {
>>> @@ -4497,6 +4515,20 @@ int iscsi_unregister_transport(struct iscsi_transport *tt)
>>>   }
>>>   EXPORT_SYMBOL_GPL(iscsi_unregister_transport);
>>>   +void iscsi_dbg_trace(void (*trace)(struct device *dev, struct va_format *),
>>> +             struct device *dev, const char *fmt, ...)
>>> +{
>>> +    struct va_format vaf;
>>> +    va_list args;
>>> +
>>> +    va_start(args, fmt);
>>> +    vaf.fmt = fmt;
>>> +    vaf.va = &args;
>>> +    trace(dev, &vaf);
>>> +    va_end(args);
>>> +}
>>> +EXPORT_SYMBOL_GPL(iscsi_dbg_trace);
>>> +
>>>   static __init int iscsi_transport_init(void)
>>>   {
>>>       int err;
>>> diff --git a/include/trace/events/iscsi.h b/include/trace/events/iscsi.h
>>> new file mode 100644
>>> index 000000000000..87408faf6e4e
>>> --- /dev/null
>>> +++ b/include/trace/events/iscsi.h
>>> @@ -0,0 +1,107 @@
>>> +#undef TRACE_SYSTEM
>>> +#define TRACE_SYSTEM iscsi
>>> +
>>> +#if !defined(_TRACE_ISCSI_H) || defined(TRACE_HEADER_MULTI_READ)
>>> +#define _TRACE_ISCSI_H
>>> +
>>> +#include <linux/tracepoint.h>
>>> +
>>> +/* max debug message length */
>>> +#define ISCSI_MSG_MAX    256
>>> +
>>> +/*
>>> + * Declare tracepoint helper function.
>>> + */
>>> +void iscsi_dbg_trace(void (*trace)(struct device *dev, struct va_format *),
>>> +             struct device *dev, const char *fmt, ...);
>>> +
>>> +/*
>>> + * Declare event class for iscsi debug messages.
>>> + */
>>> +DECLARE_EVENT_CLASS(iscsi_log_msg,
>>> +
>>> +    TP_PROTO(struct device *dev, struct va_format *vaf),
>>> +
>>> +    TP_ARGS(dev, vaf),
>>> +
>>> +    TP_STRUCT__entry(
>>> +        __string(dname,     dev_name(dev)        )
>>> +        __dynamic_array(char,    msg, ISCSI_MSG_MAX    )
>>> +    ),
>>> +
>>> +    TP_fast_assign(
>>> +        __assign_str(dname, dev_name(dev));
>>> +        vsnprintf(__get_str(msg), ISCSI_MSG_MAX, vaf->fmt, *vaf->va);
>>> +    ),
>>> +
>>> +    TP_printk("%s: %s",__get_str(dname),  __get_str(msg)
>>> +    )
>>> +);
>>> +
>>> +/*
>>> + * Define event to capture iscsi connection debug messages.
>>> + */
>>> +DEFINE_EVENT(iscsi_log_msg, iscsi_dbg_conn,
>>> +    TP_PROTO(struct device *dev, struct va_format *vaf),
>>> +
>>> +    TP_ARGS(dev, vaf)
>>> +);
>>> +
>>> +/*
>>> + * Define event to capture iscsi session debug messages.
>>> + */
>>> +DEFINE_EVENT(iscsi_log_msg, iscsi_dbg_session,
>>> +    TP_PROTO(struct device *dev, struct va_format *vaf),
>>> +
>>> +    TP_ARGS(dev, vaf)
>>> +);
>>> +
>>> +/*
>>> + * Define event to capture iscsi error handling debug messages.
>>> + */
>>> +DEFINE_EVENT(iscsi_log_msg, iscsi_dbg_eh,
>>> +        TP_PROTO(struct device *dev, struct va_format *vaf),
>>> +
>>> +        TP_ARGS(dev, vaf)
>>> +);
>>> +
>>> +/*
>>> + * Define event to capture iscsi tcp debug messages.
>>> + */
>>> +DEFINE_EVENT(iscsi_log_msg, iscsi_dbg_tcp,
>>> +        TP_PROTO(struct device *dev, struct va_format *vaf),
>>> +
>>> +        TP_ARGS(dev, vaf)
>>> +);
>>> +
>>> +/*
>>> + * Define event to capture iscsi sw tcp debug messages.
>>> + */
>>> +DEFINE_EVENT(iscsi_log_msg, iscsi_dbg_sw_tcp,
>>> +    TP_PROTO(struct device *dev, struct va_format *vaf),
>>> +
>>> +    TP_ARGS(dev, vaf)
>>> +);
>>> +
>>> +/*
>>> + * Define event to capture iscsi transport session debug messages.
>>> + */
>>> +DEFINE_EVENT(iscsi_log_msg, iscsi_dbg_trans_session,
>>> +    TP_PROTO(struct device *dev, struct va_format *vaf),
>>> +
>>> +    TP_ARGS(dev, vaf)
>>> +);
>>> +
>>> +/*
>>> + * Define event to capture iscsi transport connection debug messages.
>>> + */
>>> +DEFINE_EVENT(iscsi_log_msg, iscsi_dbg_trans_conn,
>>> +    TP_PROTO(struct device *dev, struct va_format *vaf),
>>> +
>>> +    TP_ARGS(dev, vaf)
>>> +);
>>> +
>>> +#endif /* _TRACE_ISCSI_H */
>>> +
>>> +/* This part must be outside protection */
>>> +#include <trace/define_trace.h>
>>>
>>
>> Reviewed-by: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>
>>
> 

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
